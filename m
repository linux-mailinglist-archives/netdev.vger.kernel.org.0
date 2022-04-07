Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF5A14F75F4
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 08:26:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241064AbiDGG2J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 02:28:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241045AbiDGG2H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 02:28:07 -0400
Received: from louie.mork.no (louie.mork.no [IPv6:2001:41c8:51:8a:feff:ff:fe00:e5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF7571F6879;
        Wed,  6 Apr 2022 23:26:05 -0700 (PDT)
Received: from canardo.dyn.mork.no ([IPv6:2a01:799:c9f:8600:0:0:0:1])
        (authenticated bits=0)
        by louie.mork.no (8.15.2/8.15.2) with ESMTPSA id 2376Pw0d489380
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
        Thu, 7 Apr 2022 07:26:00 +0100
Received: from miraculix.mork.no ([IPv6:2a01:799:c9f:8602:8cd5:a7b0:d07:d516])
        (authenticated bits=0)
        by canardo.dyn.mork.no (8.15.2/8.15.2) with ESMTPSA id 2376PvJT1752668
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
        Thu, 7 Apr 2022 08:25:58 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1649312758; bh=D1PIi86VaPw1LfCheCQTJFYDQIskZ/Yd8Lb1YSyamFM=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=AaBqMpTIfFkUUrP5BxwEu9YEKOXpQMxBF95SF4keaWE0TxJdgL4jxGt0JkKdNUK8d
         q9ZIFBNl2XLSs2/CN/JXU8sNG1tj5jFr2bTX5aVku6+54V39CDtuvTn7c36XZ0LWYY
         MqMe+slWNRvtx7TCXSUEGO8FcPA8LUuLcXZLl4GM=
Received: (nullmailer pid 687170 invoked by uid 1000);
        Thu, 07 Apr 2022 06:25:57 -0000
From:   =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To:     Lech Perczak <lech.perczak@gmail.com>
Cc:     netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        Kristian Evensen <kristian.evensen@gmail.com>,
        Oliver Neukum <oliver@neukum.org>
Subject: Re: [PATCH 2/3] rndis_host: enable the bogus MAC fixup for ZTE
 devices from cdc_ether
Organization: m
References: <20220407001926.11252-1-lech.perczak@gmail.com>
        <20220407001926.11252-3-lech.perczak@gmail.com>
Date:   Thu, 07 Apr 2022 08:25:57 +0200
In-Reply-To: <20220407001926.11252-3-lech.perczak@gmail.com> (Lech Perczak's
        message of "Thu, 7 Apr 2022 02:19:25 +0200")
Message-ID: <87o81d1kay.fsf@miraculix.mork.no>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Virus-Scanned: clamav-milter 0.103.5 at canardo
X-Virus-Status: Clean
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lech Perczak <lech.perczak@gmail.com> writes:

> +static int zte_rndis_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
> +{
> +	return rndis_rx_fixup(dev, skb) && usbnet_cdc_zte_rx_fixup(dev, skb);
> +}
>=20=20

Does this work as expected? Only the last ethernet packet in the rndis
frame will end up being handled by usbnet_cdc_zte_rx_fixup().  The
others are cloned and submitted directly to usbnet_skb_return().

I don't know how to best solve that, but maybe add another
RNDIS_DRIVER_DATA_x flag and test that in rndis_rx_fixup?  I.e something
like

	bool fixup_dst =3D dev->driver_info->data & RNDIS_DRIVER_DATA_FIXUP_DST:
        ..

		/* try to return all the packets in the batch */
		skb2 =3D skb_clone(skb, GFP_ATOMIC);
		if (unlikely(!skb2))
			break;
		skb_pull(skb, msg_len - sizeof *hdr);
		skb_trim(skb2, data_len);
                if (fixup_dst)
                	usbnet_cdc_zte_rx_fixup(dev, skb2);
		usbnet_skb_return(dev, skb2);
	}
        if (fixup_dst)
                usbnet_cdc_zte_rx_fixup(dev, skb);

	/* caller will usbnet_skb_return the remaining packet */
	return 1;
}



Bj=C3=B8rn
