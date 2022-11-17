Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9CFA62CF8F
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 01:28:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233981AbiKQA17 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 19:27:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233772AbiKQA1z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 19:27:55 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C255B627C1
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 16:27:53 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id p21so95492plr.7
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 16:27:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=GOfJp/fj5HzusV96DGisTfNWHmd3QApItydQHTNqdkw=;
        b=UCb1tx0XfoRRD7aMbF1pwTgDhjSL6KNbmtqzQX3q2Sq9Mj+sJ2Qz8koQ3lL1Jc5DAV
         LDtVORFYpaK70B24UJztTdIrEu2rJ8Ke7wIo/knOYNfAgSnpCGjPkyj2aFORmIjQocZg
         2/eOCqSdjoTsOHlL8ldkIbqE24X5h31zq4ABU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GOfJp/fj5HzusV96DGisTfNWHmd3QApItydQHTNqdkw=;
        b=KJT/uvc7loUxMGo5fV65Di+k0j2Z1nCrdTfJXztTulXFSCtBgzkBwrzjq/xM+BEkTP
         wRELzk2bFdL9Ew+hR+rcLR7ORVnzK8V1KVgV32ckxfJvhS3/KK9NgYnq/SsKtBV5swmT
         B/ua2Ua76kkHZ9q02ae2BZXW19NiwJoQCuBXAs3rdrSko+3A7fHNAxV0EEdL4RoQv/Js
         qlVpn7khlaxopbnpe1TW7qtj6wGhtLcoZ6tmffbGF3m+rpRZmc/IGsDm77wriW8u0Sdo
         7tBS41zjgkmEVu/WV1sAwZssJg5rBQCsASB0hvNvY8/R6k6jb/ACBAXF+N2bpsZQR1/B
         nHGA==
X-Gm-Message-State: ANoB5plCfel6woE7j3f6fKcpP1cqqul+4ucL1xM811oGRgOnba5Zo9JE
        EaZq+VXOHg5IGYRmpzWcnJYdwbZjn7wTGg==
X-Google-Smtp-Source: AA0mqf7izgIs4tamVP5xvwZJPDhJpWbrUlVRtclK4Zm0Gem7xy+bfFhhmp2zLDMVnFyCDwTaHGh3LQ==
X-Received: by 2002:a17:90a:ff84:b0:213:1e05:f992 with SMTP id hf4-20020a17090aff8400b002131e05f992mr6254360pjb.191.1668644873195;
        Wed, 16 Nov 2022 16:27:53 -0800 (PST)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id r17-20020a170903411100b00186c3727294sm12733956pld.270.2022.11.16.16.27.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Nov 2022 16:27:52 -0800 (PST)
Date:   Wed, 16 Nov 2022 16:27:51 -0800
From:   Kees Cook <keescook@chromium.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Ahern <dsahern@kernel.org>, davem@davemloft.net,
        netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH net-next v2] netlink: split up copies in the ack
 construction
Message-ID: <202211161502.142D146@keescook>
References: <20221027212553.2640042-1-kuba@kernel.org>
 <20221114023927.GA685@u2004-local>
 <20221114090614.2bfeb81c@kernel.org>
 <202211161444.04F3EDEB@keescook>
 <202211161454.D5FA4ED44@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202211161454.D5FA4ED44@keescook>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 16, 2022 at 02:56:25PM -0800, Kees Cook wrote:
> On Mon, Nov 14, 2022 at 09:06:14AM -0800, Jakub Kicinski wrote:
> > On Sun, 13 Nov 2022 19:39:27 -0700 David Ahern wrote:
> > > On Thu, Oct 27, 2022 at 02:25:53PM -0700, Jakub Kicinski wrote:
> > > > diff --git a/include/uapi/linux/netlink.h b/include/uapi/linux/netlink.h
> > > > index e2ae82e3f9f7..5da0da59bf01 100644
> > > > --- a/include/uapi/linux/netlink.h
> > > > +++ b/include/uapi/linux/netlink.h
> > > > @@ -48,6 +48,7 @@ struct sockaddr_nl {
> > > >   * @nlmsg_flags: Additional flags
> > > >   * @nlmsg_seq:   Sequence number
> > > >   * @nlmsg_pid:   Sending process port ID
> > > > + * @nlmsg_data:  Message payload
> > > >   */
> > > >  struct nlmsghdr {
> > > >  	__u32		nlmsg_len;
> > > > @@ -55,6 +56,7 @@ struct nlmsghdr {
> > > >  	__u16		nlmsg_flags;
> > > >  	__u32		nlmsg_seq;
> > > >  	__u32		nlmsg_pid;
> > > > +	__u8		nlmsg_data[];  
> > > 
> > > This breaks compile of iproute2 with clang. It does not like the
> > > variable length array in the middle of a struct. While I could re-do the
> > > structs in iproute2, I doubt it is alone in being affected by this
> > > change.
> 
> Eww.
> 
> > 
> > Kees, would you mind lending your expertise?

Perhaps this would be better? We could leave the _header_ struct alone,
but add the data to the nlmsgerr struct instead?

diff --git a/include/uapi/linux/netlink.h b/include/uapi/linux/netlink.h
index 5da0da59bf01..d0629cb343b2 100644
--- a/include/uapi/linux/netlink.h
+++ b/include/uapi/linux/netlink.h
@@ -48,7 +48,6 @@ struct sockaddr_nl {
  * @nlmsg_flags: Additional flags
  * @nlmsg_seq:   Sequence number
  * @nlmsg_pid:   Sending process port ID
- * @nlmsg_data:  Message payload
  */
 struct nlmsghdr {
 	__u32		nlmsg_len;
@@ -56,7 +55,6 @@ struct nlmsghdr {
 	__u16		nlmsg_flags;
 	__u32		nlmsg_seq;
 	__u32		nlmsg_pid;
-	__u8		nlmsg_data[];
 };
 
 /* Flags values */
@@ -121,6 +119,7 @@ struct nlmsghdr {
 struct nlmsgerr {
 	int		error;
 	struct nlmsghdr msg;
+	__u8		data[];
 	/*
 	 * followed by the message contents unless NETLINK_CAP_ACK was set
 	 * or the ACK indicates success (error == 0)
diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index b8afec32cff6..fe8493d3ae56 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -2514,8 +2514,7 @@ void netlink_ack(struct sk_buff *in_skb, struct nlmsghdr *nlh, int err,
 		if (!nlmsg_append(skb, nlmsg_len(nlh)))
 			goto err_bad_put;
 
-		memcpy(errmsg->msg.nlmsg_data, nlh->nlmsg_data,
-		       nlmsg_len(nlh));
+		memcpy(errmsg->data, nlmsg_data(nlh), nlmsg_len(nlh));
 	}
 
 	if (tlvlen)


-- 
Kees Cook
