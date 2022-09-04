Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AFC55AC517
	for <lists+netdev@lfdr.de>; Sun,  4 Sep 2022 17:44:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234344AbiIDPor convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 4 Sep 2022 11:44:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbiIDPoq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Sep 2022 11:44:46 -0400
Received: from us-smtp-delivery-44.mimecast.com (us-smtp-delivery-44.mimecast.com [207.211.30.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7386513E87
        for <netdev@vger.kernel.org>; Sun,  4 Sep 2022 08:44:43 -0700 (PDT)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-7-0_MtmQrbNYm3rrCanmms6g-1; Sun, 04 Sep 2022 11:44:37 -0400
X-MC-Unique: 0_MtmQrbNYm3rrCanmms6g-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E7578811E80;
        Sun,  4 Sep 2022 15:44:36 +0000 (UTC)
Received: from hog (unknown [10.39.192.37])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4A607492C3B;
        Sun,  4 Sep 2022 15:44:35 +0000 (UTC)
Date:   Sun, 4 Sep 2022 17:44:26 +0200
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     Emeel Hakim <ehakim@nvidia.com>
Cc:     dsahern@kernel.org, netdev@vger.kernel.org, raeds@nvidia.com,
        tariqt@nvidia.com
Subject: Re: [PATCH main v3 1/2] macsec: add Extended Packet Number support
Message-ID: <YxTH2rCZB0tMXJOr@hog>
References: <20220904074729.4804-1-ehakim@nvidia.com>
MIME-Version: 1.0
In-Reply-To: <20220904074729.4804-1-ehakim@nvidia.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2022-09-04, 10:47:28 +0300, Emeel Hakim wrote:
> @@ -174,14 +186,36 @@ static int parse_sa_args(int *argcp, char ***argvp, struct sa_desc *sa)
>  
>  	while (argc > 0) {
>  		if (strcmp(*argv, "pn") == 0) {
> -			if (sa->pn != 0)
> +			if (sa->pn.pn64 != 0)
>  				duparg2("pn", "pn");
>  			NEXT_ARG();
> -			ret = get_u32(&sa->pn, *argv, 0);
> +			ret = get_u32(&sa->pn.pn32, *argv, 0);
> +			if (ret)
> +				invarg("expected pn", *argv);
> +			if (sa->pn.pn32 == 0)
> +				invarg("expected pn != 0", *argv);
> +		} else if (strcmp(*argv, "xpn") == 0) {
> +			if (sa->pn.pn64 != 0)
> +				duparg2("xpn", "xpn");
> +			NEXT_ARG();
> +			ret = get_u64(&sa->pn.pn64, *argv, 0);
>  			if (ret)
>  				invarg("expected pn", *argv);
> -			if (sa->pn == 0)
> +			if (sa->pn.pn64 == 0)
>  				invarg("expected pn != 0", *argv);
> +			sa->xpn = true;
> +		} else if (strcmp(*argv, "salt") == 0) {
> +			unsigned int len;
> +
> +			NEXT_ARG();

That should have a duparg check.

> +			if (!hexstring_a2n(*argv, sa->salt, MACSEC_SALT_LEN,
> +					   &len))
> +				invarg("expected salt", *argv);
> +		} else if (strcmp(*argv, "ssci") == 0) {
> +			NEXT_ARG();

Also worth a duparg check.

> +			ret = get_ssci(&sa->ssci, *argv);
> +			if (ret)
> +				invarg("expected ssci", *argv);
>  		} else if (strcmp(*argv, "key") == 0) {
>  			unsigned int len;
>  
> @@ -392,9 +426,22 @@ static int do_modify_nl(enum cmd c, enum macsec_nl_commands cmd, int ifindex,
>  	addattr8(&req.n, MACSEC_BUFLEN, MACSEC_SA_ATTR_AN, sa->an);
>  
>  	if (c != CMD_DEL) {
> -		if (sa->pn)
> +		if (sa->xpn) {
> +			if (sa->pn.pn64)
> +				addattr64(&req.n, MACSEC_BUFLEN, MACSEC_SA_ATTR_PN,
> +					  sa->pn.pn64);
> +			if (sa->salt[0] != '\0')

Does the specification say the salt can't start with a 0 byte, or is
it just a "salt was set" test? If that's coming from the spec, the
kernel should also check this.

> +				addattr_l(&req.n, MACSEC_BUFLEN, MACSEC_SA_ATTR_SALT,
> +					  sa->salt, MACSEC_SALT_LEN);
> +			if (sa->ssci != 0)

Same question as for the salt.

For both, I'd just add a salt_set/ssci_set flag to sa_desc, and use it
for duparg as well.

> +				addattr32(&req.n, MACSEC_BUFLEN, MACSEC_SA_ATTR_SSCI,
> +					  sa->ssci);
> +		}
> +
> +		if (sa->pn.pn32 && !sa->xpn) {

Nit: combine this with the previous if:

    } else if (sa->pn.pn32) {


>  			addattr32(&req.n, MACSEC_BUFLEN, MACSEC_SA_ATTR_PN,
> -				  sa->pn);
> +				  sa->pn.pn32);
> +		}
>  
>  		if (sa->key_len) {
>  			addattr_l(&req.n, MACSEC_BUFLEN, MACSEC_SA_ATTR_KEYID,
> @@ -426,10 +473,11 @@ static bool check_sa_args(enum cmd c, struct sa_desc *sa)
>  			return -1;
>  		}
>  
> -		if (sa->pn == 0) {
> +		if (sa->pn.pn64 == 0) {
>  			fprintf(stderr, "must specify a packet number != 0\n");
>  			return -1;
>  		}
> +

Remove that blank line.

>  	} else if (c == CMD_UPD) {
>  		if (sa->key_len) {
>  			fprintf(stderr, "cannot change key on SA\n");

[...]
> @@ -875,8 +930,16 @@ static void print_tx_sc(const char *prefix, __u64 sci, __u8 encoding_sa,
>  		print_string(PRINT_FP, NULL, "%s", prefix);
>  		print_uint(PRINT_ANY, "an", "%d:",
>  			   rta_getattr_u8(sa_attr[MACSEC_SA_ATTR_AN]));
> -		print_uint(PRINT_ANY, "pn", " PN %u,",
> -			   rta_getattr_u32(sa_attr[MACSEC_SA_ATTR_PN]));
> +		if (!is_xpn) {

Nit: I'd flip those branches so that the test is "if (is_xpn)"

> +			print_uint(PRINT_ANY, "pn", " PN %u,",
> +				   rta_getattr_u32(sa_attr[MACSEC_SA_ATTR_PN]));
> +		} else {
> +			print_uint(PRINT_ANY, "pn", " PN %u,",
> +				   rta_getattr_u64(sa_attr[MACSEC_SA_ATTR_PN]));
> +			print_0xhex(PRINT_ANY, "ssci",
> +				    "SSCI %08x",
> +				    ntohl(rta_getattr_u32(sa_attr[MACSEC_SA_ATTR_SSCI])));
> +		}
>  
>  		print_bool(PRINT_JSON, "active", NULL, state);
>  		print_string(PRINT_FP, NULL,

[...]
> @@ -943,8 +1007,16 @@ static void print_rx_sc(const char *prefix, __be64 sci, __u8 active,
>  		print_string(PRINT_FP, NULL, "%s", prefix);
>  		print_uint(PRINT_ANY, "an", "%u:",
>  			   rta_getattr_u8(sa_attr[MACSEC_SA_ATTR_AN]));
> -		print_uint(PRINT_ANY, "pn", " PN %u,",
> -			   rta_getattr_u32(sa_attr[MACSEC_SA_ATTR_PN]));
> +		if (!is_xpn) {

Same nit, flip the test.

> +			print_uint(PRINT_ANY, "pn", " PN %u,",
> +				   rta_getattr_u32(sa_attr[MACSEC_SA_ATTR_PN]));
> +		} else {
> +			print_uint(PRINT_ANY, "pn", " PN %u,",
> +				   rta_getattr_u64(sa_attr[MACSEC_SA_ATTR_PN]));
> +			print_0xhex(PRINT_ANY, "ssci",
> +				    "SSCI %08x",
> +				    ntohl(rta_getattr_u32(sa_attr[MACSEC_SA_ATTR_SSCI])));
> +		}
>  
>  		print_bool(PRINT_JSON, "active", NULL, state);
>  		print_string(PRINT_FP, NULL, " state %s,",

[...]
> @@ -989,6 +1062,8 @@ static int process(struct nlmsghdr *n, void *arg)
>  	int ifindex;
>  	__u64 sci;
>  	__u8 encoding_sa;
> +	__u64 cid;
> +	bool is_xpn = false;
>  
>  	if (n->nlmsg_type != genl_family)
>  		return -1;
> @@ -1032,13 +1107,16 @@ static int process(struct nlmsghdr *n, void *arg)
>  
>  	print_attrs(attrs_secy);
>  
> -	print_tx_sc("    ", sci, encoding_sa,
> +	cid = rta_getattr_u64(attrs_secy[MACSEC_SECY_ATTR_CIPHER_SUITE]);
> +	if (cid == MACSEC_CIPHER_ID_GCM_AES_XPN_128 || cid == MACSEC_CIPHER_ID_GCM_AES_XPN_256)

I'd stuff that in a ciphersuite_is_xpn(cid) helper, and then it's just
    is_xpn = ciphersuite_is_xpn(cid);

> +		is_xpn = true;
> +	print_tx_sc("    ", sci, encoding_sa, is_xpn,
>  		    attrs[MACSEC_ATTR_TXSC_STATS],
>  		    attrs[MACSEC_ATTR_SECY_STATS],
>  		    attrs[MACSEC_ATTR_TXSA_LIST]);

[...]
> @@ -1268,7 +1347,7 @@ static int macsec_parse_opt(struct link_util *lu, int argc, char **argv,
>  	enum macsec_offload offload;
>  	struct cipher_args cipher = {0};
>  	enum macsec_validation_type validate;
> -	bool es = false, scb = false, send_sci = false;
> +	bool es = false, scb = false, send_sci = false, xpn = false;
>  	int replay_protect = -1;
>  	struct sci sci = { 0 };
>  
> @@ -1388,6 +1467,11 @@ static int macsec_parse_opt(struct link_util *lu, int argc, char **argv,
>  				return ret;
>  			addattr8(n, MACSEC_BUFLEN,
>  				 IFLA_MACSEC_OFFLOAD, offload);
> +		} else if (strcmp(*argv, "xpn") == 0) {
> +			NEXT_ARG();
> +			xpn = parse_on_off("xpn", *argv, &ret);

I'm not convinced the "xpn on/off" flag is the best API here. How
about just letting the admin pass the full cipher suite name
(GCM-AES-XPN-128 or GCM-AES-XPN-256)?

This xpn flag is not consistent with the dump side (which uses the
cipher suite only), and it's not consistent with the kernel API, which
also doesn't use an XPN flag but the cipher suite ID.

So I'd just add 2 options to "cipher" argument parsing (and extract
that to a new cs_name_to_id helper, since we'd now have 4 options),
and get rid of the "xpn on/off" option (and the cipher.id flip to XPN
below).

> +			if (ret != 0)
> +				return ret;
>  		} else {
>  			fprintf(stderr, "macsec: unknown command \"%s\"?\n",
>  				*argv);
> @@ -1415,6 +1499,13 @@ static int macsec_parse_opt(struct link_util *lu, int argc, char **argv,
>  		return -1;
>  	}
>  
> +	if (xpn) {
> +		if (cipher.id == MACSEC_CIPHER_ID_GCM_AES_256)
> +			cipher.id = MACSEC_CIPHER_ID_GCM_AES_XPN_256;
> +		else
> +			cipher.id = MACSEC_CIPHER_ID_GCM_AES_XPN_128;
> +	}
> +
>  	if (cipher.id)
>  		addattr_l(n, MACSEC_BUFLEN, IFLA_MACSEC_CIPHER_SUITE,
>  			  &cipher.id, sizeof(cipher.id));
> -- 
> 2.21.3
> 

-- 
Sabrina

