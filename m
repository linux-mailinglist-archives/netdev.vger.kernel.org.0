Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C26E7589F84
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 18:48:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234576AbiHDQs3 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 4 Aug 2022 12:48:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234169AbiHDQs1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Aug 2022 12:48:27 -0400
Received: from us-smtp-delivery-44.mimecast.com (us-smtp-delivery-44.mimecast.com [207.211.30.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 014231B7B6
        for <netdev@vger.kernel.org>; Thu,  4 Aug 2022 09:48:25 -0700 (PDT)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-649-RiuUCv8MPxqgcoLHX8wkRQ-1; Thu, 04 Aug 2022 12:48:14 -0400
X-MC-Unique: RiuUCv8MPxqgcoLHX8wkRQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F1D521C05144;
        Thu,  4 Aug 2022 16:48:13 +0000 (UTC)
Received: from hog (unknown [10.39.194.215])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5B1E1492C3B;
        Thu,  4 Aug 2022 16:48:12 +0000 (UTC)
Date:   Thu, 4 Aug 2022 18:48:05 +0200
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     ehakim@nvidia.com
Cc:     dsahern@kernel.org, netdev@vger.kernel.org, raeds@nvidia.com,
        tariqt@nvidia.com
Subject: Re: [PATCH main v2 2/3] macsec: add Extended Packet Number support
Message-ID: <Yuv4RXYlYE6LM2d5@hog>
References: <20220802061813.24082-1-ehakim@nvidia.com>
 <20220802061813.24082-2-ehakim@nvidia.com>
MIME-Version: 1.0
In-Reply-To: <20220802061813.24082-2-ehakim@nvidia.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Emeel,

2022-08-02, 09:18:12 +0300, ehakim@nvidia.com wrote:
> diff --git a/include/uapi/linux/if_macsec.h b/include/uapi/linux/if_macsec.h
> index eee31cec..6edfea0a 100644
> --- a/include/uapi/linux/if_macsec.h
> +++ b/include/uapi/linux/if_macsec.h
> @@ -22,6 +22,8 @@
>  
>  #define MACSEC_KEYID_LEN 16
>  
> +#define MACSEC_SALT_LEN 12

That's not in the kernel's uapi file (probably was forgotten), I
don't think we can just add it here.

[...]
> diff --git a/ip/ipmacsec.c b/ip/ipmacsec.c
> index 9aeaafcc..54ab5f39 100644
> --- a/ip/ipmacsec.c
> +++ b/ip/ipmacsec.c
> @@ -41,13 +41,33 @@ struct sci {
>  	char abuf[6];
>  };
>  
> +union __pn {
> +	struct {
> +#  if __BYTE_ORDER == __LITTLE_ENDIAN
> +		__u32 lower;
> +		__u32 upper;
> +#endif
> +# if __BYTE_ORDER == __BIG_ENDIAN
> +		__u32 upper;
> +		__u32 lower;
> +#endif
> +# if __BYTE_ORDER != __BIG_ENDIAN && __BYTE_ORDER != __LITTLE_ENDIAN
> +#error  "Please fix byteorder defines"
> +#endif
> +	};
> +	__u64 full64;
> +};

That's quite complicated and I don't really see the benefit,
especially given that upper isn't used at all here. I'd just put the
union straight in sa_desc:

>  struct sa_desc {
>  	__u8 an;
> -	__u32 pn;

+	union {
+		__u32 pn32;
+		__u64 pn64;
+	};

> +	union __pn pn;
>  	__u8 key_id[MACSEC_KEYID_LEN];
>  	__u32 key_len;
>  	__u8 key[MACSEC_MAX_KEY_LEN];
>  	__u8 active;
> +	__u8 salt[MACSEC_SALT_LEN];
> +	__u32 ssci;
> +	bool xpn;
>  };

[...]
> @@ -98,7 +124,7 @@ static void ipmacsec_usage(void)
>  		"       ip macsec show\n"
>  		"       ip macsec show DEV\n"
>  		"       ip macsec offload DEV [ off | phy | mac ]\n"
> -		"where  OPTS := [ pn <u32> ] [ on | off ]\n"
> +		"where  OPTS := [ pn <u32> ] [ xpn <u64> ] [ salt <u96> ] [ ssci <u32> ] [ on | off ]\n"

Only one of pn and xpn can be set, so that should be
	[ pn <u32> | pn64 <u64> ]

And salt is a hex string like key/keyid (it doesn't take the 0x
prefix).


[...]
> @@ -392,9 +438,29 @@ static int do_modify_nl(enum cmd c, enum macsec_nl_commands cmd, int ifindex,
>  	addattr8(&req.n, MACSEC_BUFLEN, MACSEC_SA_ATTR_AN, sa->an);
>  
>  	if (c != CMD_DEL) {
> -		if (sa->pn)
> +		if (sa->xpn) {
> +			if (sa->pn.full64)
> +				addattr64(&req.n, MACSEC_BUFLEN,
> +					  MACSEC_SA_ATTR_PN, sa->pn.full64);
> +			if (c == CMD_ADD) {
> +				addattr_l(&req.n, MACSEC_BUFLEN,
> +					  MACSEC_SA_ATTR_SALT,
> +					  sa->salt, MACSEC_SALT_LEN);
> +				if (sa->ssci != 0)
> +					addattr32(&req.n, MACSEC_BUFLEN,
> +						  MACSEC_SA_ATTR_SSCI,
> +						  sa->ssci);
> +				else
> +					addattr32(&req.n, MACSEC_BUFLEN,
> +						  MACSEC_SA_ATTR_SSCI,
> +						  DEFAULT_SSCI);

I'd rather not add a default ssci at all. If the user didn't provide
it, don't add the attribute. That would allow us to test that part of
the uapi using iproute.

Same with the 'c == CMD_ADD' test: pass the attribute to the kernel if
they're provided, let the kernel decide.

[...]
> @@ -426,10 +492,17 @@ static bool check_sa_args(enum cmd c, struct sa_desc *sa)
>  			return -1;
>  		}
>  
> -		if (sa->pn == 0) {
> +		if (sa->pn.full64 == 0) {
>  			fprintf(stderr, "must specify a packet number != 0\n");
>  			return -1;
>  		}
> +
> +		if (sa->xpn && sa->salt[0] == '\0') {
> +			fprintf(stderr,
> +				"xpn set, but no salt set.\n");
> +			return -1;

I would also allow that to be empty, same as the ssci. Let the kernel
reject invalid requests.

> +		}
> +
>  	} else if (c == CMD_UPD) {
>  		if (sa->key_len) {
>  			fprintf(stderr, "cannot change key on SA\n");
[...]

> @@ -1268,8 +1348,16 @@ static int macsec_flag_parse(__u8 *flags, int *argcp, char ***argvp)
>  	char **argv = *argvp;
>  
>  	while (1) {
> -		/* parse flag list */
> -		break;
> +		if (strcmp(*argv, "xpn") == 0) {
> +			*flags |= MACSEC_FLAGS_XPN;
> +		} else {
> +			PREV_ARG(); /* back track */
> +			break;
> +		}
> +
> +		if (!NEXT_ARG_OK())
> +			break;
> +		NEXT_ARG();
>  	}

This whole thing looks a bit over-complicated to me. Why not just put
'bool xpn = false;' in macsec_parse_opt() and match "xpn" on its own
(without "flags" in front of it) at the same level as cipher, icvlen,
etc?



I don't see anything on the print side in your patch. PNs provided by
userspace can be 64b with XPN, and SSCIs are also part of the dump and
need to be handled.

-- 
Sabrina

