Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65BF43D76FD
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 15:42:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236579AbhG0NmM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 09:42:12 -0400
Received: from serv108.segi.ulg.ac.be ([139.165.32.111]:46094 "EHLO
        serv108.segi.ulg.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232123AbhG0NmL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 09:42:11 -0400
Received: from mbx12-zne.ulg.ac.be (serv470.segi.ulg.ac.be [139.165.32.199])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by serv108.segi.ulg.ac.be (Postfix) with ESMTPS id CFA0E200EEB6;
        Tue, 27 Jul 2021 15:42:07 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 serv108.segi.ulg.ac.be CFA0E200EEB6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uliege.be;
        s=ulg20190529; t=1627393327;
        bh=9kFLOYljaUkrHkljm62d5PDyCI+CqRGZ1K1m0V0qDRo=;
        h=Date:From:Reply-To:To:Cc:In-Reply-To:References:Subject:From;
        b=hcl83hyoCvUrCY1Do1mHDAJMyb1HUWPzF5W7DYi/bBCYC3VUXcEsG8+A/ohTGVSPZ
         b23NtEIn7nU5kxYOWx6+y21D2lKHfL1bN1ysCIVfH3dqM2/DXVefvNJ8XGbV8qZhDh
         AJd2K1GyU3Z1bisSxMgywY2bt0FrOoS2LhB5d7f7npX70/Z2t2XIU9lbF+WdkXi/xD
         bLsJ+NxG6OvNIVoozkUlMS8419rSUrFopaHlEDFFPsX9ui6J8oaL8YGqHdPyyR9Yjs
         zwUu3rWgLD1LTJsoMoyG58UtzLGjL3UClRkrORozlWoEKrJgOoshlH8Ei+qunK34wk
         sANWHPaiqFaZQ==
Received: from localhost (localhost [127.0.0.1])
        by mbx12-zne.ulg.ac.be (Postfix) with ESMTP id C912260309F41;
        Tue, 27 Jul 2021 15:42:07 +0200 (CEST)
Received: from mbx12-zne.ulg.ac.be ([127.0.0.1])
        by localhost (mbx12-zne.ulg.ac.be [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id ZQD4rduZchHO; Tue, 27 Jul 2021 15:42:07 +0200 (CEST)
Received: from mbx12-zne.ulg.ac.be (mbx12-zne.ulg.ac.be [139.165.32.199])
        by mbx12-zne.ulg.ac.be (Postfix) with ESMTP id B2D5060080EF6;
        Tue, 27 Jul 2021 15:42:07 +0200 (CEST)
Date:   Tue, 27 Jul 2021 15:42:07 +0200 (CEST)
From:   Justin Iurman <justin.iurman@uliege.be>
Reply-To: Justin Iurman <justin.iurman@uliege.be>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org
Message-ID: <1187403794.27040801.1627393327692.JavaMail.zimbra@uliege.be>
In-Reply-To: <20210724172108.26524-3-justin.iurman@uliege.be>
References: <20210724172108.26524-1-justin.iurman@uliege.be> <20210724172108.26524-3-justin.iurman@uliege.be>
Subject: Re: [PATCH iproute2-next v2 2/3] New IOAM6 encap type for routes
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [81.240.24.148]
X-Mailer: Zimbra 8.8.15_GA_4018 (ZimbraWebClient - FF90 (Linux)/8.8.15_GA_4026)
Thread-Topic: New IOAM6 encap type for routes
Thread-Index: fgPISuUnz29W0pF0oq+bUmQL9U6OoQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> This patch provides a new encap type for routes to insert an IOAM pre-allocated
> trace:
> 
> $ ip -6 ro ad fc00::1/128 encap ioam6 trace type 0x800000 ns 1 size 12 dev eth0
> 
> where:
> - "trace" may appear as useless but just anticipates for future implementations
>   of other ioam option types.
> - "type" is a bitfield (=u32) defining the IOAM pre-allocated trace type (see
>   the corresponding uapi).
> - "ns" is an IOAM namespace ID attached to the pre-allocated trace.
> - "size" is the trace pre-allocated size in bytes; must be a 4-octet multiple;
>   limited size (see IOAM6_TRACE_DATA_SIZE_MAX).
> 
> Signed-off-by: Justin Iurman <justin.iurman@uliege.be>
> ---
> include/uapi/linux/ioam6.h          | 133 ++++++++++++++++++++++++++++
> include/uapi/linux/ioam6_iptunnel.h |  20 +++++
> include/uapi/linux/lwtunnel.h       |   1 +
> ip/iproute.c                        |   5 +-
> ip/iproute_lwtunnel.c               | 121 +++++++++++++++++++++++++
> 5 files changed, 278 insertions(+), 2 deletions(-)
> create mode 100644 include/uapi/linux/ioam6.h
> create mode 100644 include/uapi/linux/ioam6_iptunnel.h
> 
> diff --git a/include/uapi/linux/ioam6.h b/include/uapi/linux/ioam6.h
> new file mode 100644
> index 00000000..0a2cc17d
> --- /dev/null
> +++ b/include/uapi/linux/ioam6.h
> @@ -0,0 +1,133 @@
> +/* SPDX-License-Identifier: GPL-2.0+ WITH Linux-syscall-note */
> +/*
> + *  IPv6 IOAM implementation
> + *
> + *  Author:
> + *  Justin Iurman <justin.iurman@uliege.be>
> + */
> +
> +#ifndef _UAPI_LINUX_IOAM6_H
> +#define _UAPI_LINUX_IOAM6_H
> +
> +#include <asm/byteorder.h>
> +#include <linux/types.h>
> +
> +#define IOAM6_U16_UNAVAILABLE U16_MAX
> +#define IOAM6_U32_UNAVAILABLE U32_MAX
> +#define IOAM6_U64_UNAVAILABLE U64_MAX
> +
> +#define IOAM6_DEFAULT_ID (IOAM6_U32_UNAVAILABLE >> 8)
> +#define IOAM6_DEFAULT_ID_WIDE (IOAM6_U64_UNAVAILABLE >> 8)
> +#define IOAM6_DEFAULT_IF_ID IOAM6_U16_UNAVAILABLE
> +#define IOAM6_DEFAULT_IF_ID_WIDE IOAM6_U32_UNAVAILABLE
> +
> +/*
> + * IPv6 IOAM Option Header
> + */
> +struct ioam6_hdr {
> +	__u8 opt_type;
> +	__u8 opt_len;
> +	__u8 :8;				/* reserved */
> +#define IOAM6_TYPE_PREALLOC 0
> +	__u8 type;
> +} __attribute__((__packed__));
> +
> +/*
> + * IOAM Trace Header
> + */
> +struct ioam6_trace_hdr {
> +	__be16	namespace_id;
> +
> +#if defined(__LITTLE_ENDIAN_BITFIELD)
> +
> +	__u8	:1,				/* unused */
> +		:1,				/* unused */
> +		overflow:1,
> +		nodelen:5;
> +
> +	__u8	remlen:7,
> +		:1;				/* unused */
> +
> +	union {
> +		__be32 type_be32;
> +
> +		struct {
> +			__u32	bit7:1,
> +				bit6:1,
> +				bit5:1,
> +				bit4:1,
> +				bit3:1,
> +				bit2:1,
> +				bit1:1,
> +				bit0:1,
> +				bit15:1,	/* unused */
> +				bit14:1,	/* unused */
> +				bit13:1,	/* unused */
> +				bit12:1,	/* unused */
> +				bit11:1,
> +				bit10:1,
> +				bit9:1,
> +				bit8:1,
> +				bit23:1,	/* reserved */
> +				bit22:1,
> +				bit21:1,	/* unused */
> +				bit20:1,	/* unused */
> +				bit19:1,	/* unused */
> +				bit18:1,	/* unused */
> +				bit17:1,	/* unused */
> +				bit16:1,	/* unused */
> +				:8;		/* reserved */
> +		} type;
> +	};
> +
> +#elif defined(__BIG_ENDIAN_BITFIELD)
> +
> +	__u8	nodelen:5,
> +		overflow:1,
> +		:1,				/* unused */
> +		:1;				/* unused */
> +
> +	__u8	:1,				/* unused */
> +		remlen:7;
> +
> +	union {
> +		__be32 type_be32;
> +
> +		struct {
> +			__u32	bit0:1,
> +				bit1:1,
> +				bit2:1,
> +				bit3:1,
> +				bit4:1,
> +				bit5:1,
> +				bit6:1,
> +				bit7:1,
> +				bit8:1,
> +				bit9:1,
> +				bit10:1,
> +				bit11:1,
> +				bit12:1,	/* unused */
> +				bit13:1,	/* unused */
> +				bit14:1,	/* unused */
> +				bit15:1,	/* unused */
> +				bit16:1,	/* unused */
> +				bit17:1,	/* unused */
> +				bit18:1,	/* unused */
> +				bit19:1,	/* unused */
> +				bit20:1,	/* unused */
> +				bit21:1,	/* unused */
> +				bit22:1,
> +				bit23:1,	/* reserved */
> +				:8;		/* reserved */
> +		} type;
> +	};
> +
> +#else
> +#error "Please fix <asm/byteorder.h>"
> +#endif
> +
> +#define IOAM6_TRACE_DATA_SIZE_MAX 244
> +	__u8	data[0];
> +} __attribute__((__packed__));
> +
> +#endif /* _UAPI_LINUX_IOAM6_H */
> diff --git a/include/uapi/linux/ioam6_iptunnel.h
> b/include/uapi/linux/ioam6_iptunnel.h
> new file mode 100644
> index 00000000..bae14636
> --- /dev/null
> +++ b/include/uapi/linux/ioam6_iptunnel.h
> @@ -0,0 +1,20 @@
> +/* SPDX-License-Identifier: GPL-2.0+ WITH Linux-syscall-note */
> +/*
> + *  IPv6 IOAM Lightweight Tunnel API
> + *
> + *  Author:
> + *  Justin Iurman <justin.iurman@uliege.be>
> + */
> +
> +#ifndef _UAPI_LINUX_IOAM6_IPTUNNEL_H
> +#define _UAPI_LINUX_IOAM6_IPTUNNEL_H
> +
> +enum {
> +	IOAM6_IPTUNNEL_UNSPEC,
> +	IOAM6_IPTUNNEL_TRACE,		/* struct ioam6_trace_hdr */
> +	__IOAM6_IPTUNNEL_MAX,
> +};
> +
> +#define IOAM6_IPTUNNEL_MAX (__IOAM6_IPTUNNEL_MAX - 1)
> +
> +#endif /* _UAPI_LINUX_IOAM6_IPTUNNEL_H */
> diff --git a/include/uapi/linux/lwtunnel.h b/include/uapi/linux/lwtunnel.h
> index b7c0191f..78f0ecd1 100644
> --- a/include/uapi/linux/lwtunnel.h
> +++ b/include/uapi/linux/lwtunnel.h
> @@ -14,6 +14,7 @@ enum lwtunnel_encap_types {
> 	LWTUNNEL_ENCAP_BPF,
> 	LWTUNNEL_ENCAP_SEG6_LOCAL,
> 	LWTUNNEL_ENCAP_RPL,
> +	LWTUNNEL_ENCAP_IOAM6,
> 	__LWTUNNEL_ENCAP_MAX,
> };
> 
> diff --git a/ip/iproute.c b/ip/iproute.c
> index bdeb9644..330203b0 100644
> --- a/ip/iproute.c
> +++ b/ip/iproute.c
> @@ -101,8 +101,8 @@ static void usage(void)
> 		"TIME := NUMBER[s|ms]\n"
> 		"BOOL := [1|0]\n"
> 		"FEATURES := ecn\n"
> -		"ENCAPTYPE := [ mpls | ip | ip6 | seg6 | seg6local | rpl ]\n"
> -		"ENCAPHDR := [ MPLSLABEL | SEG6HDR | SEG6LOCAL ]\n"
> +		"ENCAPTYPE := [ mpls | ip | ip6 | seg6 | seg6local | rpl | ioam6 ]\n"
> +		"ENCAPHDR := [ MPLSLABEL | SEG6HDR | SEG6LOCAL | IOAM6HDR ]\n"
> 		"SEG6HDR := [ mode SEGMODE ] segs ADDR1,ADDRi,ADDRn [hmac HMACKEYID]
> 		[cleanup]\n"
> 		"SEGMODE := [ encap | inline ]\n"
> 		"SEG6LOCAL := action ACTION [ OPTIONS ] [ count ]\n"
> @@ -112,6 +112,7 @@ static void usage(void)
> 		"OPTIONS := OPTION [ OPTIONS ]\n"
> 		"OPTION := { srh SEG6HDR | nh4 ADDR | nh6 ADDR | iif DEV | oif DEV |\n"
> 		"            table TABLEID | vrftable TABLEID | endpoint PROGNAME }\n"
> +		"IOAM6HDR := trace type IOAM6_TRACE_TYPE ns IOAM6_NAMESPACE size
> IOAM6_TRACE_SIZE\n"
> 		"ROUTE_GET_FLAGS := [ fibmatch ]\n");
> 	exit(-1);
> }
> diff --git a/ip/iproute_lwtunnel.c b/ip/iproute_lwtunnel.c
> index c4bae68d..f1e001c4 100644
> --- a/ip/iproute_lwtunnel.c
> +++ b/ip/iproute_lwtunnel.c
> @@ -34,6 +34,8 @@
> #include <linux/seg6_hmac.h>
> #include <linux/seg6_local.h>
> #include <linux/if_tunnel.h>
> +#include <linux/ioam6.h>
> +#include <linux/ioam6_iptunnel.h>
> 
> static const char *format_encap_type(int type)
> {
> @@ -54,6 +56,8 @@ static const char *format_encap_type(int type)
> 		return "seg6local";
> 	case LWTUNNEL_ENCAP_RPL:
> 		return "rpl";
> +	case LWTUNNEL_ENCAP_IOAM6:
> +		return "ioam6";
> 	default:
> 		return "unknown";
> 	}
> @@ -90,6 +94,8 @@ static int read_encap_type(const char *name)
> 		return LWTUNNEL_ENCAP_SEG6_LOCAL;
> 	else if (strcmp(name, "rpl") == 0)
> 		return LWTUNNEL_ENCAP_RPL;
> +	else if (strcmp(name, "ioam6") == 0)
> +		return LWTUNNEL_ENCAP_IOAM6;
> 	else if (strcmp(name, "help") == 0)
> 		encap_type_usage();
> 
> @@ -204,6 +210,23 @@ static void print_encap_rpl(FILE *fp, struct rtattr *encap)
> 	print_rpl_srh(fp, srh);
> }
> 
> +static void print_encap_ioam6(FILE *fp, struct rtattr *encap)
> +{
> +	struct rtattr *tb[IOAM6_IPTUNNEL_MAX + 1];
> +	struct ioam6_trace_hdr *trace;
> +
> +	parse_rtattr_nested(tb, IOAM6_IPTUNNEL_MAX, encap);
> +
> +	if (!tb[IOAM6_IPTUNNEL_TRACE])
> +		return;
> +
> +	trace = RTA_DATA(tb[IOAM6_IPTUNNEL_TRACE]);
> +
> +	print_hex(PRINT_ANY, "type", "type %#06x ", ntohl(trace->type_be32) >> 8);

Uh oh... Should be %#08x instead, sorry for that. Should I submit a v3 to reflect it?

> +	print_uint(PRINT_ANY, "ns", "ns %u ", ntohs(trace->namespace_id));
> +	print_uint(PRINT_ANY, "size", "size %u ", trace->remlen * 4);
> +}
> +
> static const char *seg6_action_names[SEG6_LOCAL_ACTION_MAX + 1] = {
> 	[SEG6_LOCAL_ACTION_END]			= "End",
> 	[SEG6_LOCAL_ACTION_END_X]		= "End.X",
> @@ -657,6 +680,9 @@ void lwt_print_encap(FILE *fp, struct rtattr *encap_type,
> 	case LWTUNNEL_ENCAP_RPL:
> 		print_encap_rpl(fp, encap);
> 		break;
> +	case LWTUNNEL_ENCAP_IOAM6:
> +		print_encap_ioam6(fp, encap);
> +		break;
> 	}
> }
> 
> @@ -853,6 +879,98 @@ out:
> 	return ret;
> }
> 
> +static int parse_encap_ioam6(struct rtattr *rta, size_t len, int *argcp,
> +			     char ***argvp)
> +{
> +	struct ioam6_trace_hdr *trace;
> +	char **argv = *argvp;
> +	int argc = *argcp;
> +	int ns_found = 0;
> +	__u16 size = 0;
> +	__u32 type = 0;
> +	__u16 ns;
> +
> +	trace = calloc(1, sizeof(*trace));
> +	if (!trace)
> +		return -1;
> +
> +	if (strcmp(*argv, "trace"))
> +		missarg("trace");
> +
> +	while (NEXT_ARG_OK()) {
> +		NEXT_ARG_FWD();
> +
> +		if (strcmp(*argv, "type") == 0) {
> +			NEXT_ARG();
> +
> +			if (type)
> +				duparg2("type", *argv);
> +
> +			if (get_u32(&type, *argv, 0) || !type)
> +				invarg("Invalid type", *argv);
> +
> +			trace->type_be32 = htonl(type << 8);
> +
> +		} else if (strcmp(*argv, "ns") == 0) {
> +			NEXT_ARG();
> +
> +			if (ns_found++)
> +				duparg2("ns", *argv);
> +
> +			if (!type)
> +				missarg("type");
> +
> +			if (get_u16(&ns, *argv, 0))
> +				invarg("Invalid namespace ID", *argv);
> +
> +			trace->namespace_id = htons(ns);
> +
> +		} else if (strcmp(*argv, "size") == 0) {
> +			NEXT_ARG();
> +
> +			if (size)
> +				duparg2("size", *argv);
> +
> +			if (!type)
> +				missarg("type");
> +			if (!ns_found)
> +				missarg("ns");
> +
> +			if (get_u16(&size, *argv, 0) || !size)
> +				invarg("Invalid size", *argv);
> +
> +			if (size % 4)
> +				invarg("Size must be a 4-octet multiple", *argv);
> +			if (size > IOAM6_TRACE_DATA_SIZE_MAX)
> +				invarg("Size too big", *argv);
> +
> +			trace->remlen = (__u8)(size / 4);
> +
> +		} else {
> +			break;
> +		}
> +	}
> +
> +	if (!type)
> +		missarg("type");
> +	if (!ns_found)
> +		missarg("ns");
> +	if (!size)
> +		missarg("size");
> +
> +	if (rta_addattr_l(rta, len, IOAM6_IPTUNNEL_TRACE, trace,
> +			  sizeof(*trace))) {
> +		free(trace);
> +		return -1;
> +	}
> +
> +	*argcp = argc + 1;
> +	*argvp = argv - 1;
> +
> +	free(trace);
> +	return 0;
> +}
> +
> struct lwt_x {
> 	struct rtattr *rta;
> 	size_t len;
> @@ -1744,6 +1862,9 @@ int lwt_parse_encap(struct rtattr *rta, size_t len, int
> *argcp, char ***argvp,
> 	case LWTUNNEL_ENCAP_RPL:
> 		ret = parse_encap_rpl(rta, len, &argc, &argv);
> 		break;
> +	case LWTUNNEL_ENCAP_IOAM6:
> +		ret = parse_encap_ioam6(rta, len, &argc, &argv);
> +		break;
> 	default:
> 		fprintf(stderr, "Error: unsupported encap type\n");
> 		break;
> --
> 2.25.1
