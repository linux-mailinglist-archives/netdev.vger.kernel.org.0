Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76756233354
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 15:47:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728325AbgG3Nri (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 09:47:38 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:57660 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726281AbgG3Nrh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 09:47:37 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 06UDlWqd095379;
        Thu, 30 Jul 2020 08:47:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1596116852;
        bh=SnY4IJzNmWOwcsTU47tujhAkaOUygDAfU16TsRF244A=;
        h=Subject:From:To:References:Date:In-Reply-To;
        b=k2Gwrb1BzOmGlF4j1mc2j36539ewCLeXvz/4yV9VMmhHJWX8Y5gQtcGhF3aIVnPRG
         KmwR4hXzxJ2VYa4eNP0/opo/TWdKRoaW1O1WAbXVugXGh6YHfrFER/qa+AcIpYs6N8
         zl3B38CKCkt4LMqDPmr7A00YwEyyaSeWpsd0eEOI=
Received: from DLEE115.ent.ti.com (dlee115.ent.ti.com [157.170.170.26])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 06UDlWNq073880
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 30 Jul 2020 08:47:32 -0500
Received: from DLEE111.ent.ti.com (157.170.170.22) by DLEE115.ent.ti.com
 (157.170.170.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 30
 Jul 2020 08:47:31 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE111.ent.ti.com
 (157.170.170.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 30 Jul 2020 08:47:31 -0500
Received: from [10.250.53.226] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 06UDlVrl055436;
        Thu, 30 Jul 2020 08:47:31 -0500
Subject: Re: [net-next iproute2 PATCH v3 1/2] iplink: hsr: add support for
 creating PRP device similar to HSR
From:   Murali Karicheri <m-karicheri2@ti.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-api@vger.kernel.org>,
        <nsekhar@ti.com>, <grygorii.strashko@ti.com>,
        <vinicius.gomes@intel.com>
References: <20200717152205.826-1-m-karicheri2@ti.com>
Message-ID: <75fb8843-0b93-0755-0350-c2c91dfc4f91@ti.com>
Date:   Thu, 30 Jul 2020 09:47:31 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200717152205.826-1-m-karicheri2@ti.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

On 7/17/20 11:22 AM, Murali Karicheri wrote:
> This patch enhances the iplink command to add a proto parameters to
> create PRP device/interface similar to HSR. Both protocols are
> quite similar and requires a pair of Ethernet interfaces. So re-use
> the existing HSR iplink command to create PRP device/interface as
> well. Use proto parameter to differentiate the two protocols.
> 
> Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
> ---
>   dependent on the series "[net-next PATCH v3 0/7] Add PRP driver"
>   include/uapi/linux/if_link.h | 12 +++++++++++-
>   ip/iplink_hsr.c              | 19 +++++++++++++++++--
>   2 files changed, 28 insertions(+), 3 deletions(-)
> 
> diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
> index a8901a39a345..fa2e3f642deb 100644
> --- a/include/uapi/linux/if_link.h
> +++ b/include/uapi/linux/if_link.h
> @@ -904,7 +904,14 @@ enum {
>   #define IFLA_IPOIB_MAX (__IFLA_IPOIB_MAX - 1)
>   
>   
> -/* HSR section */
> +/* HSR/PRP section, both uses same interface */
> +
> +/* Different redundancy protocols for hsr device */
> +enum {
> +	HSR_PROTOCOL_HSR,
> +	HSR_PROTOCOL_PRP,
> +	HSR_PROTOCOL_MAX,
> +};
>   
>   enum {
>   	IFLA_HSR_UNSPEC,
> @@ -914,6 +921,9 @@ enum {
>   	IFLA_HSR_SUPERVISION_ADDR,	/* Supervision frame multicast addr */
>   	IFLA_HSR_SEQ_NR,
>   	IFLA_HSR_VERSION,		/* HSR version */
> +	IFLA_HSR_PROTOCOL,		/* Indicate different protocol than
> +					 * HSR. For example PRP.
> +					 */
>   	__IFLA_HSR_MAX,
>   };
>   
> diff --git a/ip/iplink_hsr.c b/ip/iplink_hsr.c
> index 7d9167d4e6a3..6ea138a23cbc 100644
> --- a/ip/iplink_hsr.c
> +++ b/ip/iplink_hsr.c
> @@ -25,7 +25,7 @@ static void print_usage(FILE *f)
>   {
>   	fprintf(f,
>   		"Usage:\tip link add name NAME type hsr slave1 SLAVE1-IF slave2 SLAVE2-IF\n"
> -		"\t[ supervision ADDR-BYTE ] [version VERSION]\n"
> +		"\t[ supervision ADDR-BYTE ] [version VERSION] [proto PROTOCOL]\n"
>   		"\n"
>   		"NAME\n"
>   		"	name of new hsr device (e.g. hsr0)\n"
> @@ -35,7 +35,9 @@ static void print_usage(FILE *f)
>   		"	0-255; the last byte of the multicast address used for HSR supervision\n"
>   		"	frames (default = 0)\n"
>   		"VERSION\n"
> -		"	0,1; the protocol version to be used. (default = 0)\n");
> +		"	0,1; the protocol version to be used. (default = 0)\n"
> +		"PROTOCOL\n"
> +		"	0 - HSR, 1 - PRP. (default = 0 - HSR)\n");
>   }
>   
>   static void usage(void)
> @@ -49,6 +51,7 @@ static int hsr_parse_opt(struct link_util *lu, int argc, char **argv,
>   	int ifindex;
>   	unsigned char multicast_spec;
>   	unsigned char protocol_version;
> +	unsigned char protocol = HSR_PROTOCOL_HSR;
>   
>   	while (argc > 0) {
>   		if (matches(*argv, "supervision") == 0) {
> @@ -64,6 +67,13 @@ static int hsr_parse_opt(struct link_util *lu, int argc, char **argv,
>   				invarg("version is invalid", *argv);
>   			addattr_l(n, 1024, IFLA_HSR_VERSION,
>   				  &protocol_version, 1);
> +		} else if (matches(*argv, "proto") == 0) {
> +			NEXT_ARG();
> +			if (!(get_u8(&protocol, *argv, 0) == HSR_PROTOCOL_HSR ||
> +			      get_u8(&protocol, *argv, 0) == HSR_PROTOCOL_PRP))
> +				invarg("protocol is invalid", *argv);
> +			addattr_l(n, 1024, IFLA_HSR_PROTOCOL,
> +				  &protocol, 1);
>   		} else if (matches(*argv, "slave1") == 0) {
>   			NEXT_ARG();
>   			ifindex = ll_name_to_index(*argv);
> @@ -140,6 +150,11 @@ static void hsr_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
>   					 RTA_PAYLOAD(tb[IFLA_HSR_SUPERVISION_ADDR]),
>   					 ARPHRD_VOID,
>   					 b1, sizeof(b1)));
> +	if (tb[IFLA_HSR_PROTOCOL])
> +		print_int(PRINT_ANY,
> +			  "proto",
> +			  "proto %d ",
> +			  rta_getattr_u8(tb[IFLA_HSR_PROTOCOL]));
>   }
>   
>   static void hsr_print_help(struct link_util *lu, int argc, char **argv,
> 
Just wondering who will merge this now that PRP support series below
is applied to net-next. These iproute2 patches have to go along with 
that to have full PRP support working.

https://lkml.org/lkml/2020/7/22/638

-- 
Murali Karicheri
Texas Instruments
