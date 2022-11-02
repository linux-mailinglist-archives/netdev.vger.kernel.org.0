Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52C556165B9
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 16:05:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230174AbiKBPFJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 11:05:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbiKBPFH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 11:05:07 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 839BA5F47;
        Wed,  2 Nov 2022 08:05:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A8740CE219E;
        Wed,  2 Nov 2022 15:05:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91911C433D6;
        Wed,  2 Nov 2022 15:05:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667401501;
        bh=kz7LNX0cY+Ka5OlMguNBshZZKfLrinPrLpJ9udBnCQ8=;
        h=Date:From:To:CC:Subject:In-Reply-To:References:From;
        b=jseDN6PfwU4ULWTqShI9rUzJk3uhfYLeeY1XWVHfAE5yCsOtJLX2CpgOosVb/kE65
         2QST8wRaVuRYw/JmqR114k3o5IBoLuDxluFPgQpgesZII70QrJUacZYZUR12URHEag
         PxjuardU/Zcqgktm2aMSGSR+AWf/+ppqHrKqQkibDOwmmbZOSbhTUz8K4rO0+7VzbM
         9RgIbTNm9SUuWc8JA3SPBZS+YfVqLsjtV+vGjiPn0v5jElrSUEqIqOMaHhl/sVLpGZ
         lWAoHq0jcG0CegUfaTgIqozZXtWdYwpl5RfTb74eKeboJ5RLCNKH8DqgAKv9ns+nRt
         wUSkxMkOsn/qw==
Date:   Wed, 02 Nov 2022 08:05:00 -0700
From:   Kees Cook <kees@kernel.org>
To:     Tao Chen <chentao.kernel@linux.alibaba.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Petr Machata <petrm@nvidia.com>,
        Kees Cook <keescook@chromium.org>,
        Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
CC:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_net-next=5D_netlink=3A_Fix_p?= =?US-ASCII?Q?otential_skb_memleak_in_netlink=5Fack?=
User-Agent: K-9 Mail for Android
In-Reply-To: <7a382b9503d10d235238ca55938bc933d92a1de7.1667389213.git.chentao.kernel@linux.alibaba.com>
References: <7a382b9503d10d235238ca55938bc933d92a1de7.1667389213.git.chentao.kernel@linux.alibaba.com>
Message-ID: <1F03859F-2819-462D-83B7-7A4067847432@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On November 2, 2022 5:08:20 AM PDT, Tao Chen <chentao=2Ekernel@linux=2Ealib=
aba=2Ecom> wrote:
>We should clean the skb resource if nlmsg_put/append failed
>, so fix it=2E
>
>Fiexs: commit 738136a0e375 ("netlink: split up copies in the
>ack construction")
>Signed-off-by: Tao Chen <chentao=2Ekernel@linux=2Ealibaba=2Ecom>
>---
> net/netlink/af_netlink=2Ec | 4 +++-
> 1 file changed, 3 insertions(+), 1 deletion(-)
>
>diff --git a/net/netlink/af_netlink=2Ec b/net/netlink/af_netlink=2Ec
>index c6b8207e=2E=2E9d73dae 100644
>--- a/net/netlink/af_netlink=2Ec
>+++ b/net/netlink/af_netlink=2Ec
>@@ -2500,7 +2500,7 @@ void netlink_ack(struct sk_buff *in_skb, struct nlm=
sghdr *nlh, int err,
>=20
> 	skb =3D nlmsg_new(payload + tlvlen, GFP_KERNEL);
> 	if (!skb)
>-		goto err_bad_put;
>+		goto err_skb;
>=20
> 	rep =3D nlmsg_put(skb, NETLINK_CB(in_skb)=2Eportid, nlh->nlmsg_seq,
> 			NLMSG_ERROR, sizeof(*errmsg), flags);
>@@ -2528,6 +2528,8 @@ void netlink_ack(struct sk_buff *in_skb, struct nlm=
sghdr *nlh, int err,
> 	return;
>=20
> err_bad_put:
>+	kfree_skb(skb);
>+err_skb:
> 	NETLINK_CB(in_skb)=2Esk->sk_err =3D ENOBUFS;
> 	sk_error_report(NETLINK_CB(in_skb)=2Esk);
> }

It didn't do this before=2E=2E=2E Is this right?


--=20
Kees Cook
