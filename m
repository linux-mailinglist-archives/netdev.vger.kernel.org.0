Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55FA85ED965
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 11:46:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233344AbiI1Jq2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 05:46:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233331AbiI1JqZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 05:46:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C73A97EC3;
        Wed, 28 Sep 2022 02:46:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 76EE961DF0;
        Wed, 28 Sep 2022 09:46:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94527C433D7;
        Wed, 28 Sep 2022 09:46:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664358382;
        bh=RZA8bVJ6dd3T0As/xD/fr6Bwe14u2sb4g+iLozlr43I=;
        h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
        b=Ske6XeEsQkdTFWP+UsjRuAyZ70Y6kB1E35FPUfzPzq/zjFcAH7ccZTUJ3wfX9JsJO
         aRRjRvKuiUeIQ/GUhByE10JIn8V9vqNwlmITCqYYj1mqN6Gc4lk/We0OzBC1PvXhKw
         KA4ZFVWy4s3l0sLNX9Eb2sfy8/25QbQiZvX7hZ+icDftOv3OZpmFcqdiYxpq07Alk6
         E2eR02GXQlWsHlBvgLn4EWf5u/6ze5uTj9qwF6BJel2LUa9u1fHru2XQQ9ghHNkpoP
         RSEOss6wybnMCxIDFfmfUMjICv/rXgzfCzP1jlnqLjuEBL6eH5Lv5/SpU0du/6oJxb
         XqE5qtY6Q6yGQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <YzOjEqBMtF+Ib72v@chmeee>
References: <YzOjEqBMtF+Ib72v@chmeee>
Subject: Re: new warning caused by ("net-sysfs: update the queue counts in the unregistration path")
From:   Antoine Tenart <atenart@kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
To:     Kevin Mitchell <kevmitch@arista.com>
Date:   Wed, 28 Sep 2022 11:46:20 +0200
Message-ID: <166435838013.3919.14607521178984182789@kwain>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Quoting Kevin Mitchell (2022-09-28 03:27:46)
> With the inclusion of d7dac083414e ("net-sysfs: update the queue counts i=
n the
> unregistration path"), we have started see the following message during o=
ne of
> our stress tests that brings an interface up and down while continuously
> trying to send out packets on it:
>=20
> et3_11_1 selects TX queue 0, but real number of TX queues is 0
>=20
> It seems that this is a result of a race between remove_queue_kobjects() =
and
> netdev_cap_txqueue() for the last packets before setting dev->flags &=3D =
~IFF_UP
> in __dev_close_many(). When this message is displayed, netdev_cap_txqueue=
()
> selects queue 0 anyway (the noop queue at this point). As it did before t=
he
> above commit, that queue (which I guess is still around due to reference
> counting) proceeds to drop the packet and return NET_XMIT_CN. So there do=
esn't
> appear to be a functional change. However, the warning message seems to be
> spurious if not slightly confusing.

Do you know the call traces leading to this? Also I'm not 100% sure to
follow as remove_queue_kobjects is called in the unregistration path
while the test is setting the iface up & down. What driver is used?

As you said and looking around queue 0 is somewhat special and used as a
fallback. My suggestion would be to 1) check if the above race is
expected 2) if yes, a possible solution would be not to warn when
real_num_tx_queues =3D=3D 0 as in such cases selecting queue 0 would be the
expected fallback (and you might want to check places like [1]).

Thanks,
Antoine

[1] https://elixir.bootlin.com/linux/latest/source/net/core/dev.c#L4126
