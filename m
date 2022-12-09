Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 453B6648886
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 19:35:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229901AbiLISfq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 13:35:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbiLISfp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 13:35:45 -0500
Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [85.215.255.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 165715F6E9;
        Fri,  9 Dec 2022 10:35:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1670610940;
    s=strato-dkim-0002; d=hartkopp.net;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=EDWwRjKB927nNLSfG8my1y5rwjZ9GPC4JIWFtDJN42k=;
    b=E54Q+RrR7j530IZg2mDxQnYVohqX6AN+Cl2CF+kaKw8AF+nGO6vPFWl7xbjCfQ3Nmo
    MPVFrMfYeDmYPwxF37GKaKrI1cUdwlTf8rpy+V77zdhz4xdTbxJqrCUCJPaCPBA+MDMG
    4vXoehbq+gay5Vtmjj7iwJtCGP2a/yD09EPRkBOJ5p6LqgVStS7IJlVCYWZj8mmkfCTZ
    Kp1AzGum5sQnujBbI8zpA1V1TQGruFWcxePf7Cc+vU7jQqLmaxIYDIDyjWL/ajE5fVCA
    9DmZzUSnM88OM0JyQ2tC24E1nPqWjICBXxz9XMITrioiTOmTNc/h3NKBWyKQRiGeJX8e
    hJtg==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1o3TMaFqTEVR5J8xpzl0="
X-RZG-CLASS-ID: mo00
Received: from [192.168.60.87]
    by smtp.strato.de (RZmta 48.2.1 DYNA|AUTH)
    with ESMTPSA id Dde783yB9IZe76h
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Fri, 9 Dec 2022 19:35:40 +0100 (CET)
Message-ID: <49f3bce6-dc9a-60c7-0772-010edb8d0363@hartkopp.net>
Date:   Fri, 9 Dec 2022 19:35:34 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH stable] can: af_can: fix NULL pointer dereference in
 can_rcv_filter
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     netdev@vger.kernel.org, linux-can@vger.kernel.org,
        syzbot+2d7f58292cb5b29eb5ad@syzkaller.appspotmail.com,
        Wei Chen <harperchen1110@gmail.com>
References: <20221209180745.2977-1-socketcan@hartkopp.net>
Content-Language: en-US
From:   Oliver Hartkopp <socketcan@hartkopp.net>
In-Reply-To: <20221209180745.2977-1-socketcan@hartkopp.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Just checked that the stable patch for 8aa59e355949 ("can: af_can: fix 
NULL pointer dereference in can_rx_register()") has been applied down to 
linux-5.4.y

Same works with this patch.

Just the current 6.1-rc has some changes in this section which makes 
this backport stable patch necessary.

Best,
Oliver


On 09.12.22 19:07, Oliver Hartkopp wrote:
> Analogue to commit 8aa59e355949 ("can: af_can: fix NULL pointer
> dereference in can_rx_register()") we need to check for a missing
> initialization of ml_priv in the receive path of CAN frames.
> 
> Since commit 4e096a18867a ("net: introduce CAN specific pointer in the
> struct net_device") the check for dev->type to be ARPHRD_CAN is not
> sufficient anymore since bonding or tun netdevices claim to be CAN
> devices but do not initialize ml_priv accordingly.
> 
> Upstream commit 0acc442309a0 ("can: af_can: fix NULL pointer
> dereference in can_rcv_filter")
> 
> Fixes: 4e096a18867a ("net: introduce CAN specific pointer in the struct net_device")
> Reported-by: syzbot+2d7f58292cb5b29eb5ad@syzkaller.appspotmail.com
> Reported-by: Wei Chen <harperchen1110@gmail.com>
> Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
> Cc: stable@vger.kernel.org # 5.12 .. 6.0
> ---
>   net/can/af_can.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/can/af_can.c b/net/can/af_can.c
> index 1fb49d51b25d..4392f1d9c027 100644
> --- a/net/can/af_can.c
> +++ b/net/can/af_can.c
> @@ -678,11 +678,11 @@ static void can_receive(struct sk_buff *skb, struct net_device *dev)
>   static int can_rcv(struct sk_buff *skb, struct net_device *dev,
>   		   struct packet_type *pt, struct net_device *orig_dev)
>   {
>   	struct canfd_frame *cfd = (struct canfd_frame *)skb->data;
>   
> -	if (unlikely(dev->type != ARPHRD_CAN || skb->len != CAN_MTU)) {
> +	if (unlikely(dev->type != ARPHRD_CAN || !can_get_ml_priv(dev) || skb->len != CAN_MTU)) {
>   		pr_warn_once("PF_CAN: dropped non conform CAN skbuff: dev type %d, len %d\n",
>   			     dev->type, skb->len);
>   		goto free_skb;
>   	}
>   
> @@ -704,11 +704,11 @@ static int can_rcv(struct sk_buff *skb, struct net_device *dev,
>   static int canfd_rcv(struct sk_buff *skb, struct net_device *dev,
>   		     struct packet_type *pt, struct net_device *orig_dev)
>   {
>   	struct canfd_frame *cfd = (struct canfd_frame *)skb->data;
>   
> -	if (unlikely(dev->type != ARPHRD_CAN || skb->len != CANFD_MTU)) {
> +	if (unlikely(dev->type != ARPHRD_CAN || !can_get_ml_priv(dev) || skb->len != CANFD_MTU)) {
>   		pr_warn_once("PF_CAN: dropped non conform CAN FD skbuff: dev type %d, len %d\n",
>   			     dev->type, skb->len);
>   		goto free_skb;
>   	}
>   
