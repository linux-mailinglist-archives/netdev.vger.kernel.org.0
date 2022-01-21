Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 035514959E1
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 07:25:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378685AbiAUGZg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 01:25:36 -0500
Received: from smtp-relay-internal-1.canonical.com ([185.125.188.123]:56754
        "EHLO smtp-relay-internal-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1343580AbiAUGZg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 01:25:36 -0500
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com [209.85.210.197])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 361EE3FFD9
        for <netdev@vger.kernel.org>; Fri, 21 Jan 2022 06:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1642746329;
        bh=i9Ze4chfphs7HSToLW+VPmaVGM0gBG5wn9WWFVp0dKo=;
        h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
         Content-Type:Date:Message-ID;
        b=szgHl61EikKfRMTZNxyG2ekAIg/dqt7NRtBZTigs9AWBuIcgf+dr8BXlp9Sh7EUpj
         AiC0slE5YLw8kMvcAu6tRBYxmrTBHIHf4cj2NsBojTtHrskfsEjOXjiRSHeQXK0xeQ
         9VWcf+1srXaZCOcZMGM1VzupRkQjI4GjdML4YPLiW83HpbXFrQIj2a1NZVd3CsUOX2
         LZ4c4j1+2qAgr8Y1Tc4I87ugSjkSQQZY81F/w7Kj3CJ5IRZx5CJ9gjXt6dcuU3HQ+7
         nYBiimziz7z1zJjJg9UqtMl/i6GoZ0tAiiahKxV4+h1S7HUjqJTDMI/S3tLFHZXx4y
         XbFOj33TeFxRQ==
Received: by mail-pf1-f197.google.com with SMTP id x22-20020a056a00189600b004be094fc848so5477032pfh.8
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 22:25:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references
         :comments:mime-version:content-id:content-transfer-encoding:date
         :message-id;
        bh=i9Ze4chfphs7HSToLW+VPmaVGM0gBG5wn9WWFVp0dKo=;
        b=PwfHhr59Oc15cg0XaeZhTPdKJVt7lZxiVv6sXowwHA1QLIJ+KPgDPiZlb6hXPchewJ
         idBqyzntnwD93G4zDUlEC4mbBRznCShLFGMLrO4+spkh6bMERCHgyS+maWC8+LYZNOA8
         em53VcRHVTTBvsvlhC9v50HOesi3wMPuZA3y3EY/PMDFm3CsMU5B/Tprf+8JPyf4QKd+
         0mfYSVCgeVxtDUnFUPOgCTwxhaT9ukg3fXyqgROYJpQz/4h+oePdLjpb9j45xwmPmZXB
         tDPm7vY44naZXIl/cTT/hoQqfgpO/SfQ08nllvp6NnZXZGaHsEqtOmHgCXMJGCwqTBf1
         01jQ==
X-Gm-Message-State: AOAM531MPGkiq4x4eEGclfgnGlCFXqNQha0bG0WcSPEYH2NBJ15zBS0s
        mu7aviK+PxR/MFKLDBRXRxo+quBdAjxon1bjbp0ZAmzYDpCBpo7lIenJxdlZiZHSmtzrLBkxKgj
        /KWBNLtKP7bZCXykSw+OQ2mR5Dpk6ozJ0hw==
X-Received: by 2002:a17:903:22ca:b0:14a:74e6:b994 with SMTP id y10-20020a17090322ca00b0014a74e6b994mr2720954plg.87.1642746327523;
        Thu, 20 Jan 2022 22:25:27 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxZ1YnUWKQJfdmy48bT3s6TU1mjeOaaBYK0f7fZ21BvGoF+6Y97eV3+xhR/02gZFy2dN6sWtg==
X-Received: by 2002:a17:903:22ca:b0:14a:74e6:b994 with SMTP id y10-20020a17090322ca00b0014a74e6b994mr2720936plg.87.1642746327298;
        Thu, 20 Jan 2022 22:25:27 -0800 (PST)
Received: from famine.localdomain ([50.125.80.157])
        by smtp.gmail.com with ESMTPSA id 202sm4104386pga.72.2022.01.20.22.25.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 20 Jan 2022 22:25:26 -0800 (PST)
Received: by famine.localdomain (Postfix, from userid 1000)
        id 5E7CF6093D; Thu, 20 Jan 2022 22:25:26 -0800 (PST)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id 56D85A0B22;
        Thu, 20 Jan 2022 22:25:26 -0800 (PST)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Sun Shouxin <sunshouxin@chinatelecom.cn>
cc:     vfalico@gmail.com, andy@greyhouse.net, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, huyd12@chinatelecom.cn
Subject: Re: [PATCH v6] net: bonding: Add support for IPV6 ns/na to balance-alb/balance-tlb mode
In-reply-to: <20220118073317.82968-1-sunshouxin@chinatelecom.cn>
References: <20220118073317.82968-1-sunshouxin@chinatelecom.cn>
Comments: In-reply-to Sun Shouxin <sunshouxin@chinatelecom.cn>
   message dated "Tue, 18 Jan 2022 02:33:17 -0500."
X-Mailer: MH-E 8.6+git; nmh 1.6; Emacs 29.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <29468.1642746326.1@famine>
Content-Transfer-Encoding: quoted-printable
Date:   Thu, 20 Jan 2022 22:25:26 -0800
Message-ID: <29469.1642746326@famine>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sun Shouxin <sunshouxin@chinatelecom.cn> wrote:

>Since ipv6 neighbor solicitation and advertisement messages
>isn't handled gracefully in bonding6 driver, we can see packet
>drop due to inconsistency bewteen mac address in the option
>message and source MAC .
>
>Another examples is ipv6 neighbor solicitation and advertisement
>messages from VM via tap attached to host brighe, the src mac
>mighe be changed through balance-alb mode, but it is not synced
>with Link-layer address in the option message.
>
>The patch implements bond6's tx handle for ipv6 neighbor
>solicitation and advertisement messages.

	As previously discussed, this looks reasonable to me to resolve
the described MAC discrepancy.  One minor nit is a couple of misspelled
words in the description above, "brighe" and "mighe."

Acked-by: Jay Vosburgh <jay.vosburgh@canonical.com>

	-J

>Suggested-by: Hu Yadi <huyd12@chinatelecom.cn>
>Reported-by: kernel test robot <lkp@intel.com>
>Signed-off-by: Sun Shouxin <sunshouxin@chinatelecom.cn>
>---
> drivers/net/bonding/bond_alb.c | 36 ++++++++++++++++++++++++++++++++++
> 1 file changed, 36 insertions(+)
>
>diff --git a/drivers/net/bonding/bond_alb.c b/drivers/net/bonding/bond_al=
b.c
>index 533e476988f2..82b7071840b1 100644
>--- a/drivers/net/bonding/bond_alb.c
>+++ b/drivers/net/bonding/bond_alb.c
>@@ -1269,6 +1269,34 @@ static int alb_set_mac_address(struct bonding *bon=
d, void *addr)
> 	return res;
> }
> =

>+/*determine if the packet is NA or NS*/
>+static bool __alb_determine_nd(struct icmp6hdr *hdr)
>+{
>+	if (hdr->icmp6_type =3D=3D NDISC_NEIGHBOUR_ADVERTISEMENT ||
>+	    hdr->icmp6_type =3D=3D NDISC_NEIGHBOUR_SOLICITATION) {
>+		return true;
>+	}
>+
>+	return false;
>+}
>+
>+static bool alb_determine_nd(struct sk_buff *skb, struct bonding *bond)
>+{
>+	struct ipv6hdr *ip6hdr;
>+	struct icmp6hdr *hdr;
>+
>+	if (skb->protocol =3D=3D htons(ETH_P_IPV6)) {
>+		ip6hdr =3D ipv6_hdr(skb);
>+		if (ip6hdr->nexthdr =3D=3D IPPROTO_ICMPV6) {
>+			hdr =3D icmp6_hdr(skb);
>+			if (__alb_determine_nd(hdr))
>+				return true;
>+		}
>+	}
>+
>+	return false;
>+}
>+
> /************************ exported alb functions ***********************=
*/
> =

> int bond_alb_initialize(struct bonding *bond, int rlb_enabled)
>@@ -1350,6 +1378,9 @@ struct slave *bond_xmit_tlb_slave_get(struct bondin=
g *bond,
> 		switch (skb->protocol) {
> 		case htons(ETH_P_IP):
> 		case htons(ETH_P_IPV6):
>+			if (alb_determine_nd(skb, bond))
>+				break;
>+
> 			hash_index =3D bond_xmit_hash(bond, skb);
> 			if (bond->params.tlb_dynamic_lb) {
> 				tx_slave =3D tlb_choose_channel(bond,
>@@ -1446,6 +1477,11 @@ struct slave *bond_xmit_alb_slave_get(struct bondi=
ng *bond,
> 			break;
> 		}
> =

>+		if (alb_determine_nd(skb, bond)) {
>+			do_tx_balance =3D false;
>+			break;
>+		}
>+
> 		hash_start =3D (char *)&ip6hdr->daddr;
> 		hash_size =3D sizeof(ip6hdr->daddr);
> 		break;
>
>base-commit: 79e06c4c4950be2abd8ca5d2428a8c915aa62c24
>-- =

>2.27.0
>

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
