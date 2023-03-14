Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18EC86B8D99
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 09:40:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230280AbjCNIkG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 04:40:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229999AbjCNIjj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 04:39:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02FF92B636;
        Tue, 14 Mar 2023 01:38:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A6337B818A1;
        Tue, 14 Mar 2023 08:38:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3667C433D2;
        Tue, 14 Mar 2023 08:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678783135;
        bh=Rhzgorm4ZUHhjMMA+zANP8RvH0VKUtX4fjFcZ0DdL6g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VYkzTozr5uRd0rB+nGIGZaUfXVQ1xvqMf2jsSCwgz4SwLQRgzpgAU7WMNXgpiFEGu
         I0o8w4p3E/pic8ZzS9C5fsPrSLN4GD/qlXnvnLdIizoUdrWmghQ2+aQ8KEDLXE+MyA
         UrL3511NhD8zmlyXyHJI+i0LAAppwknhEqo/xntjorzrjrPpwIZw36Kr6vCdJMqawm
         Ax7RZo9jEmvyqsAxFZ2r7QRZ+txiTJ8Fc2uZiWehxj12LbcRIkGe/ocFuMrsAhmxNA
         b0Pl/uxKvthm/sDEOJckP2pvimNbaxqAlVlk8LuAgWmjjrNTtHnsGJS3spRA5N3cRC
         fs0ok76GgL3Nw==
Date:   Tue, 14 Mar 2023 09:38:43 +0100
From:   Christian Brauner <brauner@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Anjali Kulkarni <anjali.k.kulkarni@oracle.com>,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        zbr@ioremap.net, johannes@sipsolutions.net, ecree.xilinx@gmail.com,
        leon@kernel.org, keescook@chromium.org, socketcan@hartkopp.net,
        petrm@nvidia.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v1 2/5] connector/cn_proc: Add filtering to fix some bugs
Message-ID: <20230314083843.wb3xmzboejxfg73b@wittgenstein>
References: <20230310221547.3656194-1-anjali.k.kulkarni@oracle.com>
 <20230310221547.3656194-3-anjali.k.kulkarni@oracle.com>
 <20230313172441.480c9ec7@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230313172441.480c9ec7@kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 13, 2023 at 05:24:41PM -0700, Jakub Kicinski wrote:
> On Fri, 10 Mar 2023 14:15:44 -0800 Anjali Kulkarni wrote:
> > diff --git a/include/linux/connector.h b/include/linux/connector.h
> > index 487350bb19c3..1336a5e7dd2f 100644
> > --- a/include/linux/connector.h
> > +++ b/include/linux/connector.h
> > @@ -96,7 +96,11 @@ void cn_del_callback(const struct cb_id *id);
> >   *
> >   * If there are no listeners for given group %-ESRCH can be returned.
> >   */
> > -int cn_netlink_send_mult(struct cn_msg *msg, u16 len, u32 portid, u32 group, gfp_t gfp_mask);
> > +int cn_netlink_send_mult(struct cn_msg *msg, u16 len, u32 portid,
> > +			 u32 group, gfp_t gfp_mask,
> > +			 int (*filter)(struct sock *dsk, struct sk_buff *skb,
> > +				       void *data),
> > +			 void *filter_data);
> 
> kdoc needs to be extended

just a thought from my side. I think giving access to unprivileged users
will require a little thought as that's potentially sensitive.

If possible I would think that the patches that don't lead to a
behavioral change should go in completely independently and then we can
discuss the non-root access change.
