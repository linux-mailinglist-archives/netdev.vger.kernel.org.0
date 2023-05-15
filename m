Return-Path: <netdev+bounces-2509-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 060AD7024AC
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 08:28:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B201128110F
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 06:28:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 927AE539A;
	Mon, 15 May 2023 06:28:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FB93538C
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 06:28:30 +0000 (UTC)
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B76499
	for <netdev@vger.kernel.org>; Sun, 14 May 2023 23:28:27 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id 5b1f17b1804b1-3f435658d23so60460505e9.3
        for <netdev@vger.kernel.org>; Sun, 14 May 2023 23:28:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1684132106; x=1686724106;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NblqyHj1jPdvKtZnjswzIcSKDLF6U7a8syOnrcpqFdM=;
        b=BxbOQ0UQu6IOrl/3BqvSEDXr6mPjOcBF6Gd7SLi6FDqvLUWt+fjK0IaaMSEquVQjRF
         dxF7wpV0EkA3/+Xt2wWC+MEcsSa0SMefmvluidb4iP4tyO2bMggnGZoiwgLJk44HjXGh
         hZby7dMO668+BtM3yaDMcsahTFZEm74xb0ubR9Iw/e4SA5/wpNsrgBSJxBVMdeMoUFpX
         hPcw0En1D0dsyL4QfjzrwhH2ECRXvsrjsN1l/rRO1QNMZ6GzWbWGiTyMHMP7IACoyXks
         b5WN+236fsDCcTAvVfxHdDPHj5QagGenanToVc3drqU1I+Kn3jcDgBqUhyt5HsLtDnsv
         5cfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684132106; x=1686724106;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NblqyHj1jPdvKtZnjswzIcSKDLF6U7a8syOnrcpqFdM=;
        b=lCUjZpGKFm/3iYlPmNnFfmpvESEyUNKp6QvdE5IEk7AA9HHrZc3GjVh+mS2tAH23ZN
         2Hl48TXSDezVU0Y2dhVTMRg4cuVQ7W3kzsZ5GeW/9PMHeLK+E3ywvb5vrLSyX+YLttkO
         vZyYazL4MyauvdeSV4OfjPyqu87DvD29QaZ59hEBNS1PqbgxVj0PTUy0Hv6YB00ASJL3
         nGALnJdUutuFaf3MJ6CjW1O1sNgc+q3CGvQrkWX3lqls/eot+QDEpafGv2w5StIHap/C
         wcdZ099T6JqNAZDuUA396EyT3Tk6STEGiRklydhEpsaeur/JgfkTZzEV6Xic01v51MNu
         Cstg==
X-Gm-Message-State: AC+VfDzd37L/rLrkVcl3zyYVFw/unVh4xofnMUUcTPHEVXFqBuqZbGVh
	YFxEK3LwrVdL8SPs9/h1oSO9w5tEuod4owm7SiY=
X-Google-Smtp-Source: ACHHUZ6LJ1S9/HKvZz9KIX3nzkBvk0CYODCeF2EQiDBhglBuPHDJRw2OlBCavYPFXCe621ZkKuT+FQ==
X-Received: by 2002:a7b:c454:0:b0:3f4:2297:630a with SMTP id l20-20020a7bc454000000b003f42297630amr18922708wmi.20.1684132105963;
        Sun, 14 May 2023 23:28:25 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id k11-20020a7bc40b000000b003f4247fbb5fsm22530487wmi.10.2023.05.14.23.28.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 May 2023 23:28:23 -0700 (PDT)
Date: Mon, 15 May 2023 09:28:18 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: oe-kbuild@lists.linux.dev, Edward Cree <ecree.xilinx@gmail.com>
Cc: lkp@intel.com, oe-kbuild-all@lists.linux.dev, netdev@vger.kernel.org
Subject: [net-next:main 21/23] drivers/net/ethernet/sfc/tc.c:501
 efx_tc_flower_record_encap_match() error: dereferencing freed memory 'encap'
Message-ID: <bc9afc30-bd48-4afc-8b83-a7f5bd6fe64a@kili.mountain>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git main
head:   ba79e9a73284f576f336814125571432a2b3940f
commit: 3c9561c0a5b988be3dfd24ea1de2301b95efc640 [21/23] sfc: support TC decap rules matching on enc_ip_tos
config: microblaze-randconfig-m031-20230509 (https://download.01.org/0day-ci/archive/20230513/202305132017.hOzgJtBt-lkp@intel.com/config)
compiler: microblaze-linux-gcc (GCC) 12.1.0

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Reported-by: Dan Carpenter <error27@gmail.com>
| Link: https://lore.kernel.org/r/202305132017.hOzgJtBt-lkp@intel.com/

New smatch warnings:
drivers/net/ethernet/sfc/tc.c:501 efx_tc_flower_record_encap_match() error: dereferencing freed memory 'encap'
drivers/net/ethernet/sfc/tc.c:529 efx_tc_flower_record_encap_match() warn: missing unwind goto?

Old smatch warnings:
drivers/net/ethernet/sfc/tc.c:515 efx_tc_flower_record_encap_match() error: dereferencing freed memory 'encap'
drivers/net/ethernet/sfc/tc.c:971 efx_tc_flower_replace() warn: missing unwind goto?

vim +/encap +501 drivers/net/ethernet/sfc/tc.c

746224cdef013e Edward Cree 2023-03-27  375  static int efx_tc_flower_record_encap_match(struct efx_nic *efx,
746224cdef013e Edward Cree 2023-03-27  376  					    struct efx_tc_match *match,
746224cdef013e Edward Cree 2023-03-27  377  					    enum efx_encap_type type,
3c9561c0a5b988 Edward Cree 2023-05-11  378  					    enum efx_tc_em_pseudo_type em_type,
3c9561c0a5b988 Edward Cree 2023-05-11  379  					    u8 child_ip_tos_mask,
746224cdef013e Edward Cree 2023-03-27  380  					    struct netlink_ext_ack *extack)
746224cdef013e Edward Cree 2023-03-27  381  {
3c9561c0a5b988 Edward Cree 2023-05-11  382  	struct efx_tc_encap_match *encap, *old, *pseudo = NULL;
746224cdef013e Edward Cree 2023-03-27  383  	bool ipv6 = false;
746224cdef013e Edward Cree 2023-03-27  384  	int rc;
746224cdef013e Edward Cree 2023-03-27  385  
746224cdef013e Edward Cree 2023-03-27  386  	/* We require that the socket-defining fields (IP addrs and UDP dest
3c9561c0a5b988 Edward Cree 2023-05-11  387  	 * port) are present and exact-match.  Other fields may only be used
3c9561c0a5b988 Edward Cree 2023-05-11  388  	 * if the field-set (and any masks) are the same for all encap
3c9561c0a5b988 Edward Cree 2023-05-11  389  	 * matches on the same <sip,dip,dport> tuple; this is enforced by
3c9561c0a5b988 Edward Cree 2023-05-11  390  	 * pseudo encap matches.
746224cdef013e Edward Cree 2023-03-27  391  	 */
746224cdef013e Edward Cree 2023-03-27  392  	if (match->mask.enc_dst_ip | match->mask.enc_src_ip) {
746224cdef013e Edward Cree 2023-03-27  393  		if (!IS_ALL_ONES(match->mask.enc_dst_ip)) {
746224cdef013e Edward Cree 2023-03-27  394  			NL_SET_ERR_MSG_MOD(extack,
746224cdef013e Edward Cree 2023-03-27  395  					   "Egress encap match is not exact on dst IP address");
746224cdef013e Edward Cree 2023-03-27  396  			return -EOPNOTSUPP;
746224cdef013e Edward Cree 2023-03-27  397  		}
746224cdef013e Edward Cree 2023-03-27  398  		if (!IS_ALL_ONES(match->mask.enc_src_ip)) {
746224cdef013e Edward Cree 2023-03-27  399  			NL_SET_ERR_MSG_MOD(extack,
746224cdef013e Edward Cree 2023-03-27  400  					   "Egress encap match is not exact on src IP address");
746224cdef013e Edward Cree 2023-03-27  401  			return -EOPNOTSUPP;
746224cdef013e Edward Cree 2023-03-27  402  		}
746224cdef013e Edward Cree 2023-03-27  403  #ifdef CONFIG_IPV6
746224cdef013e Edward Cree 2023-03-27  404  		if (!ipv6_addr_any(&match->mask.enc_dst_ip6) ||
746224cdef013e Edward Cree 2023-03-27  405  		    !ipv6_addr_any(&match->mask.enc_src_ip6)) {
746224cdef013e Edward Cree 2023-03-27  406  			NL_SET_ERR_MSG_MOD(extack,
746224cdef013e Edward Cree 2023-03-27  407  					   "Egress encap match on both IPv4 and IPv6, don't understand");
746224cdef013e Edward Cree 2023-03-27  408  			return -EOPNOTSUPP;
746224cdef013e Edward Cree 2023-03-27  409  		}
746224cdef013e Edward Cree 2023-03-27  410  	} else {
746224cdef013e Edward Cree 2023-03-27  411  		ipv6 = true;
746224cdef013e Edward Cree 2023-03-27  412  		if (!efx_ipv6_addr_all_ones(&match->mask.enc_dst_ip6)) {
746224cdef013e Edward Cree 2023-03-27  413  			NL_SET_ERR_MSG_MOD(extack,
746224cdef013e Edward Cree 2023-03-27  414  					   "Egress encap match is not exact on dst IP address");
746224cdef013e Edward Cree 2023-03-27  415  			return -EOPNOTSUPP;
746224cdef013e Edward Cree 2023-03-27  416  		}
746224cdef013e Edward Cree 2023-03-27  417  		if (!efx_ipv6_addr_all_ones(&match->mask.enc_src_ip6)) {
746224cdef013e Edward Cree 2023-03-27  418  			NL_SET_ERR_MSG_MOD(extack,
746224cdef013e Edward Cree 2023-03-27  419  					   "Egress encap match is not exact on src IP address");
746224cdef013e Edward Cree 2023-03-27  420  			return -EOPNOTSUPP;
746224cdef013e Edward Cree 2023-03-27  421  		}
746224cdef013e Edward Cree 2023-03-27  422  #endif
746224cdef013e Edward Cree 2023-03-27  423  	}
746224cdef013e Edward Cree 2023-03-27  424  	if (!IS_ALL_ONES(match->mask.enc_dport)) {
746224cdef013e Edward Cree 2023-03-27  425  		NL_SET_ERR_MSG_MOD(extack, "Egress encap match is not exact on dst UDP port");
746224cdef013e Edward Cree 2023-03-27  426  		return -EOPNOTSUPP;
746224cdef013e Edward Cree 2023-03-27  427  	}
746224cdef013e Edward Cree 2023-03-27  428  	if (match->mask.enc_sport) {
746224cdef013e Edward Cree 2023-03-27  429  		NL_SET_ERR_MSG_MOD(extack, "Egress encap match on src UDP port not supported");
746224cdef013e Edward Cree 2023-03-27  430  		return -EOPNOTSUPP;
746224cdef013e Edward Cree 2023-03-27  431  	}
746224cdef013e Edward Cree 2023-03-27  432  	if (match->mask.enc_ip_tos) {
3c9561c0a5b988 Edward Cree 2023-05-11  433  		struct efx_tc_match pmatch = *match;
3c9561c0a5b988 Edward Cree 2023-05-11  434  
3c9561c0a5b988 Edward Cree 2023-05-11  435  		if (em_type == EFX_TC_EM_PSEUDO_MASK) { /* can't happen */
3c9561c0a5b988 Edward Cree 2023-05-11  436  			NL_SET_ERR_MSG_MOD(extack, "Bad recursion in egress encap match handler");
746224cdef013e Edward Cree 2023-03-27  437  			return -EOPNOTSUPP;
746224cdef013e Edward Cree 2023-03-27  438  		}
3c9561c0a5b988 Edward Cree 2023-05-11  439  		pmatch.value.enc_ip_tos = 0;
3c9561c0a5b988 Edward Cree 2023-05-11  440  		pmatch.mask.enc_ip_tos = 0;
3c9561c0a5b988 Edward Cree 2023-05-11  441  		rc = efx_tc_flower_record_encap_match(efx, &pmatch, type,
3c9561c0a5b988 Edward Cree 2023-05-11  442  						      EFX_TC_EM_PSEUDO_MASK,
3c9561c0a5b988 Edward Cree 2023-05-11  443  						      match->mask.enc_ip_tos,
3c9561c0a5b988 Edward Cree 2023-05-11  444  						      extack);
3c9561c0a5b988 Edward Cree 2023-05-11  445  		if (rc)
3c9561c0a5b988 Edward Cree 2023-05-11  446  			return rc;
3c9561c0a5b988 Edward Cree 2023-05-11  447  		pseudo = pmatch.encap;
3c9561c0a5b988 Edward Cree 2023-05-11  448  	}
746224cdef013e Edward Cree 2023-03-27  449  	if (match->mask.enc_ip_ttl) {
746224cdef013e Edward Cree 2023-03-27  450  		NL_SET_ERR_MSG_MOD(extack, "Egress encap match on IP TTL not supported");
3c9561c0a5b988 Edward Cree 2023-05-11  451  		rc = -EOPNOTSUPP;
3c9561c0a5b988 Edward Cree 2023-05-11  452  		goto fail_pseudo;
746224cdef013e Edward Cree 2023-03-27  453  	}
746224cdef013e Edward Cree 2023-03-27  454  
56beb35d85e290 Edward Cree 2023-05-11  455  	rc = efx_mae_check_encap_match_caps(efx, ipv6, match->mask.enc_ip_tos, extack);
56beb35d85e290 Edward Cree 2023-05-11  456  	if (rc)
3c9561c0a5b988 Edward Cree 2023-05-11  457  		goto fail_pseudo;
746224cdef013e Edward Cree 2023-03-27  458  
746224cdef013e Edward Cree 2023-03-27  459  	encap = kzalloc(sizeof(*encap), GFP_USER);
3c9561c0a5b988 Edward Cree 2023-05-11  460  	if (!encap) {
3c9561c0a5b988 Edward Cree 2023-05-11  461  		rc = -ENOMEM;
3c9561c0a5b988 Edward Cree 2023-05-11  462  		goto fail_pseudo;
3c9561c0a5b988 Edward Cree 2023-05-11  463  	}
746224cdef013e Edward Cree 2023-03-27  464  	encap->src_ip = match->value.enc_src_ip;
746224cdef013e Edward Cree 2023-03-27  465  	encap->dst_ip = match->value.enc_dst_ip;
746224cdef013e Edward Cree 2023-03-27  466  #ifdef CONFIG_IPV6
746224cdef013e Edward Cree 2023-03-27  467  	encap->src_ip6 = match->value.enc_src_ip6;
746224cdef013e Edward Cree 2023-03-27  468  	encap->dst_ip6 = match->value.enc_dst_ip6;
746224cdef013e Edward Cree 2023-03-27  469  #endif
746224cdef013e Edward Cree 2023-03-27  470  	encap->udp_dport = match->value.enc_dport;
746224cdef013e Edward Cree 2023-03-27  471  	encap->tun_type = type;
3c9561c0a5b988 Edward Cree 2023-05-11  472  	encap->ip_tos = match->value.enc_ip_tos;
3c9561c0a5b988 Edward Cree 2023-05-11  473  	encap->ip_tos_mask = match->mask.enc_ip_tos;
3c9561c0a5b988 Edward Cree 2023-05-11  474  	encap->child_ip_tos_mask = child_ip_tos_mask;
3c9561c0a5b988 Edward Cree 2023-05-11  475  	encap->type = em_type;
3c9561c0a5b988 Edward Cree 2023-05-11  476  	encap->pseudo = pseudo;
746224cdef013e Edward Cree 2023-03-27  477  	old = rhashtable_lookup_get_insert_fast(&efx->tc->encap_match_ht,
746224cdef013e Edward Cree 2023-03-27  478  						&encap->linkage,
746224cdef013e Edward Cree 2023-03-27  479  						efx_tc_encap_match_ht_params);
746224cdef013e Edward Cree 2023-03-27  480  	if (old) {

The latest versions of Smatch want an IS_ERR() check:

	old = rhashtable_lookup_get_insert_fast();
	if (IS_ERR(old)) {
		rc = PTR_ERR(old);
		goto fail_pseudo;
	}
	if (old) {

746224cdef013e Edward Cree 2023-03-27  481  		/* don't need our new entry */
746224cdef013e Edward Cree 2023-03-27  482  		kfree(encap);
                                                        ^^^^^^^^^^^^^
Freed.

3c9561c0a5b988 Edward Cree 2023-05-11  483  		if (pseudo) /* don't need our new pseudo either */
3c9561c0a5b988 Edward Cree 2023-05-11  484  			efx_tc_flower_release_encap_match(efx, pseudo);
3c9561c0a5b988 Edward Cree 2023-05-11  485  		/* check old and new em_types are compatible */
3c9561c0a5b988 Edward Cree 2023-05-11  486  		switch (old->type) {
3c9561c0a5b988 Edward Cree 2023-05-11  487  		case EFX_TC_EM_DIRECT:
3c9561c0a5b988 Edward Cree 2023-05-11  488  			/* old EM is in hardware, so mustn't overlap with a
3c9561c0a5b988 Edward Cree 2023-05-11  489  			 * pseudo, but may be shared with another direct EM
3c9561c0a5b988 Edward Cree 2023-05-11  490  			 */
3c9561c0a5b988 Edward Cree 2023-05-11  491  			if (em_type == EFX_TC_EM_DIRECT)
3c9561c0a5b988 Edward Cree 2023-05-11  492  				break;
3c9561c0a5b988 Edward Cree 2023-05-11  493  			NL_SET_ERR_MSG_MOD(extack, "Pseudo encap match conflicts with existing direct entry");
3c9561c0a5b988 Edward Cree 2023-05-11  494  			return -EEXIST;

Do we not have to call rhashtable_remove_fast() on these error paths?

3c9561c0a5b988 Edward Cree 2023-05-11  495  		case EFX_TC_EM_PSEUDO_MASK:
3c9561c0a5b988 Edward Cree 2023-05-11  496  			/* old EM is protecting a ToS-qualified filter, so may
3c9561c0a5b988 Edward Cree 2023-05-11  497  			 * only be shared with another pseudo for the same
3c9561c0a5b988 Edward Cree 2023-05-11  498  			 * ToS mask.
3c9561c0a5b988 Edward Cree 2023-05-11  499  			 */
3c9561c0a5b988 Edward Cree 2023-05-11  500  			if (em_type != EFX_TC_EM_PSEUDO_MASK) {
3c9561c0a5b988 Edward Cree 2023-05-11 @501  				NL_SET_ERR_MSG_FMT_MOD(extack,
3c9561c0a5b988 Edward Cree 2023-05-11  502  						       "%s encap match conflicts with existing pseudo(MASK) entry",
3c9561c0a5b988 Edward Cree 2023-05-11  503  						       encap->type ? "Pseudo" : "Direct");
                                                                                               ^^^^^^^^^^^
Dereferenced.

3c9561c0a5b988 Edward Cree 2023-05-11  504  				return -EEXIST;
3c9561c0a5b988 Edward Cree 2023-05-11  505  			}
3c9561c0a5b988 Edward Cree 2023-05-11  506  			if (child_ip_tos_mask != old->child_ip_tos_mask) {
3c9561c0a5b988 Edward Cree 2023-05-11  507  				NL_SET_ERR_MSG_FMT_MOD(extack,
3c9561c0a5b988 Edward Cree 2023-05-11  508  						       "Pseudo encap match for TOS mask %#04x conflicts with existing pseudo(MASK) entry for TOS mask %#04x",
3c9561c0a5b988 Edward Cree 2023-05-11  509  						       child_ip_tos_mask,
3c9561c0a5b988 Edward Cree 2023-05-11  510  						       old->child_ip_tos_mask);
3c9561c0a5b988 Edward Cree 2023-05-11  511  				return -EEXIST;
3c9561c0a5b988 Edward Cree 2023-05-11  512  			}
3c9561c0a5b988 Edward Cree 2023-05-11  513  			break;
3c9561c0a5b988 Edward Cree 2023-05-11  514  		default: /* Unrecognised pseudo-type.  Just say no */
3c9561c0a5b988 Edward Cree 2023-05-11  515  			NL_SET_ERR_MSG_FMT_MOD(extack,
3c9561c0a5b988 Edward Cree 2023-05-11  516  					       "%s encap match conflicts with existing pseudo(%d) entry",
3c9561c0a5b988 Edward Cree 2023-05-11  517  					       encap->type ? "Pseudo" : "Direct",
3c9561c0a5b988 Edward Cree 2023-05-11  518  					       old->type);
3c9561c0a5b988 Edward Cree 2023-05-11  519  			return -EEXIST;
3c9561c0a5b988 Edward Cree 2023-05-11  520  		}
3c9561c0a5b988 Edward Cree 2023-05-11  521  		/* check old and new tun_types are compatible */
746224cdef013e Edward Cree 2023-03-27  522  		if (old->tun_type != type) {
746224cdef013e Edward Cree 2023-03-27  523  			NL_SET_ERR_MSG_FMT_MOD(extack,
746224cdef013e Edward Cree 2023-03-27  524  					       "Egress encap match with conflicting tun_type %u != %u",
746224cdef013e Edward Cree 2023-03-27  525  					       old->tun_type, type);
746224cdef013e Edward Cree 2023-03-27  526  			return -EEXIST;
746224cdef013e Edward Cree 2023-03-27  527  		}
746224cdef013e Edward Cree 2023-03-27  528  		if (!refcount_inc_not_zero(&old->ref))
746224cdef013e Edward Cree 2023-03-27 @529  			return -EAGAIN;
746224cdef013e Edward Cree 2023-03-27  530  		/* existing entry found */
746224cdef013e Edward Cree 2023-03-27  531  		encap = old;
746224cdef013e Edward Cree 2023-03-27  532  	} else {
3c9561c0a5b988 Edward Cree 2023-05-11  533  		if (em_type == EFX_TC_EM_DIRECT) {
746224cdef013e Edward Cree 2023-03-27  534  			rc = efx_mae_register_encap_match(efx, encap);
746224cdef013e Edward Cree 2023-03-27  535  			if (rc) {
746224cdef013e Edward Cree 2023-03-27  536  				NL_SET_ERR_MSG_MOD(extack, "Failed to record egress encap match in HW");
746224cdef013e Edward Cree 2023-03-27  537  				goto fail;
746224cdef013e Edward Cree 2023-03-27  538  			}
3c9561c0a5b988 Edward Cree 2023-05-11  539  		}
746224cdef013e Edward Cree 2023-03-27  540  		refcount_set(&encap->ref, 1);
746224cdef013e Edward Cree 2023-03-27  541  	}
746224cdef013e Edward Cree 2023-03-27  542  	match->encap = encap;
746224cdef013e Edward Cree 2023-03-27  543  	return 0;
746224cdef013e Edward Cree 2023-03-27  544  fail:
746224cdef013e Edward Cree 2023-03-27  545  	rhashtable_remove_fast(&efx->tc->encap_match_ht, &encap->linkage,
746224cdef013e Edward Cree 2023-03-27  546  			       efx_tc_encap_match_ht_params);
746224cdef013e Edward Cree 2023-03-27  547  	kfree(encap);
3c9561c0a5b988 Edward Cree 2023-05-11  548  fail_pseudo:
3c9561c0a5b988 Edward Cree 2023-05-11  549  	if (pseudo)
3c9561c0a5b988 Edward Cree 2023-05-11  550  		efx_tc_flower_release_encap_match(efx, pseudo);
746224cdef013e Edward Cree 2023-03-27  551  	return rc;
746224cdef013e Edward Cree 2023-03-27  552  }

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests


