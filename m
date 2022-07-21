Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD04B57C1BB
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 02:50:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229606AbiGUAt6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 20:49:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiGUAt5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 20:49:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 619B6753B1
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 17:49:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9346E61E83
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 00:49:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ED3CC341C7;
        Thu, 21 Jul 2022 00:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658364594;
        bh=3r7sC3Kgqm7fjugv5vlpraNc+pm7AHhxBwwujBexinE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EfjNznnAbXFL9cdBl5OhGzXxpm+B72Fuz5c70RFIf90tiKd+DfuDWqqpp1NdHZUIu
         83rBs/31ix/xbF7+tFmTclG4MTKsmR7DKfDKRE6QAp9hXV4wWiiI2QAgi0hQAG7hAf
         ueUWwk2kmcDvEIAIvEl9YrjSrqZk+rCo3B1SsSmWSHcEI9PAwLcAGHydGD+taQ/gxI
         6ae0Dsxd64eLz/3gWbfPHxOUTAT3wEWUGJaTFAUOMhFDMEXldI+1RlkKMWJx8iSPUU
         pKBZuhpCr5zs8r9uabPLAr7ZxoRp8aR6OHljW6tZ+er0MSJJb+/mYu53BIoX72AWCZ
         dDOzjgEa6yl6A==
Date:   Wed, 20 Jul 2022 17:49:53 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, idosch@nvidia.com,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com, saeedm@nvidia.com, snelson@pensando.io
Subject: Re: [patch net-next v3 01/11] net: devlink: make sure that
 devlink_try_get() works with valid pointer during xarray iteration
Message-ID: <20220720174953.707bcfa9@kernel.org>
In-Reply-To: <20220720151234.3873008-2-jiri@resnulli.us>
References: <20220720151234.3873008-1-jiri@resnulli.us>
        <20220720151234.3873008-2-jiri@resnulli.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 20 Jul 2022 17:12:24 +0200 Jiri Pirko wrote:
> +static void __devlink_put_rcu(struct rcu_head *head)
> +{
> +	struct devlink *devlink = container_of(head, struct devlink, rcu);
> +
> +	complete(&devlink->comp);
> +}
> +
>  void devlink_put(struct devlink *devlink)
>  {
>  	if (refcount_dec_and_test(&devlink->refcount))
> -		complete(&devlink->comp);
> +		/* Make sure unregister operation that may await the completion
> +		 * is unblocked only after all users are after the end of
> +		 * RCU grace period.
> +		 */
> +		call_rcu(&devlink->rcu, __devlink_put_rcu);
>  }

Hm. I always assumed we'd just use the xa_lock(). Unmarking the
instance as registered takes that lock which provides a natural 
barrier for others trying to take a reference.

Something along these lines (untested):

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 98d79feeb3dc..6321ea123f79 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -278,6 +278,38 @@ void devl_unlock(struct devlink *devlink)
 }
 EXPORT_SYMBOL_GPL(devl_unlock);
 
+static struct devlink *devlink_iter_next(unsigned long *index)
+{
+	struct devlink *devlink;
+
+	xa_lock(&devlinks);
+	devlink = xa_find_after(&devlinks, index, ULONG_MAX,
+				DEVLINK_REGISTERED);
+	if (devlink && !refcount_inc_not_zero(&devlink->refcount))
+		devlink = NULL;
+	xa_unlock(&devlinks);
+
+	return devlink ?: devlink_iter_next(index);
+}
+
+static struct devlink *devlink_iter_start(unsigned long *index)
+{
+	struct devlink *devlink;
+
+	xa_lock(&devlinks);
+	devlink = xa_find(&devlinks, index, ULONG_MAX, DEVLINK_REGISTERED);
+	if (devlink && !refcount_inc_not_zero(&devlink->refcount))
+		devlink = NULL;
+	xa_unlock(&devlinks);
+
+	return devlink ?: devlink_iter_next(index);
+}
+
+#define devlink_for_each_get(index, entry)			\
+	for (index = 0, entry = devlink_iter_start(&index);	\
+	     entry; entry = devlink_iter_next(&index))
+
 static struct devlink *devlink_get_from_attrs(struct net *net,
 					      struct nlattr **attrs)
 {
@@ -1329,10 +1361,7 @@ static int devlink_nl_cmd_rate_get_dumpit(struct sk_buff *msg,
 	int err = 0;
 
 	mutex_lock(&devlink_mutex);
-	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
-		if (!devlink_try_get(devlink))
-			continue;
-
+	devlink_for_each_get(index, devlink) {
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
 			goto retry;
 
etc.

Plus we need to be more careful about the unregistering order, I
believe the correct ordering is:

	clear_unmark()
	put()
	wait()
	notify()

but I believe we'll run afoul of Leon's notification suppression.
So I guess notify() has to go before clear_unmark(), but we should
unmark before we wait otherwise we could live lock (once the mutex 
is really gone, I mean).
