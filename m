Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5532E4D1D1F
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 17:26:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348295AbiCHQ11 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 11:27:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348110AbiCHQ10 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 11:27:26 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DAB1E50474
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 08:26:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646756786;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=T2AL3azyXwS+YdQGr7WwE+BEYV704EZWT30IdZo6h2w=;
        b=LrOZ8hy8DFhdE+srrsXoqsA1wLSKsLiN+yOoMbZfs6SiV2eXnAs2gkHV3MxXr8nk64QoFC
        Tox5gOLKZflx0G3iKJhZcUX/v5Es1P3hbSNhV09LLHp62Jm4EQDD7k2FcKeacW23XjBwO7
        wI9EvIsqRN3R2LzjogMy9oBcZIUYj+s=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-655-A04yVuIuNBWjEhnZfRoX7w-1; Tue, 08 Mar 2022 11:26:25 -0500
X-MC-Unique: A04yVuIuNBWjEhnZfRoX7w-1
Received: by mail-wr1-f72.google.com with SMTP id h11-20020a5d430b000000b001f01a35a86fso5629449wrq.4
        for <netdev@vger.kernel.org>; Tue, 08 Mar 2022 08:26:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=T2AL3azyXwS+YdQGr7WwE+BEYV704EZWT30IdZo6h2w=;
        b=1zv0P+GgJjhfji+XUeJSfmCr/NLFP92jLwTMTjErXckeqhtSC2N6hmoOxGi/rw35GN
         ga6vyor4stLcXcMzQ1TJTr5MQDa8+15za3iv2yIglZTeDKxeIG2E3g1xw04fjXF2FvnT
         m3BR5LdW/lHPqYx70rKJ5KRfjIkkaE1Jai8SPVFbR/hw4LxO04wIC+V5k4nIjuXQ8yuw
         E949CwDqusHeZBUBdZHNb4R0ofcga0+R+UxWNyxDKTVNVjarxm9z+cASrSWmg6IPzn0h
         UvbrngpvOl3gx+ek8HdTCF1wS4cC2pGX6PEDBHRi7XNJIS6ajHrk1/7JPdF7iNPKUFIm
         WcZA==
X-Gm-Message-State: AOAM530c0+kMxGRQNxfSt0+AM1K7yvyG13e889l9edAlvAu4KHH8IlbM
        eAG62ObyGHPrBEdqWtFrCzd7UDhFFuKHHJXeP1IcKONt4pGmFKQ5/fr/06KpzWxLZFqRxcLjZyP
        qvss2vOnQSNkagRW+
X-Received: by 2002:adf:eb45:0:b0:1ef:6070:7641 with SMTP id u5-20020adfeb45000000b001ef60707641mr13354531wrn.301.1646756784447;
        Tue, 08 Mar 2022 08:26:24 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyhnyFnkO7umByqQJsfdzQVHFeLrYMLRMWEEu3NiZVMI6SXrE3spWUAqmE+Oa2Azw0YWMSP3w==
X-Received: by 2002:adf:eb45:0:b0:1ef:6070:7641 with SMTP id u5-20020adfeb45000000b001ef60707641mr13354522wrn.301.1646756784232;
        Tue, 08 Mar 2022 08:26:24 -0800 (PST)
Received: from redhat.com ([2.55.24.184])
        by smtp.gmail.com with ESMTPSA id m3-20020a5d6243000000b001e33760776fsm14270303wrv.10.2022.03.08.08.26.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 08:26:23 -0800 (PST)
Date:   Tue, 8 Mar 2022 11:26:19 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     kernel test robot <lkp@intel.com>
Cc:     zhenwei pi <pizhenwei@bytedance.com>, kbuild-all@lists.01.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, lei he <helei.sig11@bytedance.com>,
        Gonglei <arei.gonglei@huawei.com>
Subject: Re: [mst-vhost:vhost 28/60] nios2-linux-ld:
 virtio_crypto_akcipher_algs.c:undefined reference to `rsa_parse_pub_key'
Message-ID: <20220308112417-mutt-send-email-mst@kernel.org>
References: <202203090014.ulENdnAQ-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202203090014.ulENdnAQ-lkp@intel.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 09, 2022 at 12:10:30AM +0800, kernel test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git vhost
> head:   c5f633abfd09491ae7ecbc7fcfca08332ad00a8b
> commit: 8a75f36b5d7a48f1c5a0b46638961c951ec6ecd9 [28/60] virtio-crypto: implement RSA algorithm
> config: nios2-randconfig-p002-20220308 (https://download.01.org/0day-ci/archive/20220309/202203090014.ulENdnAQ-lkp@intel.com/config)
> compiler: nios2-linux-gcc (GCC) 11.2.0
> reproduce (this is a W=1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git/commit/?id=8a75f36b5d7a48f1c5a0b46638961c951ec6ecd9
>         git remote add mst-vhost https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git
>         git fetch --no-tags mst-vhost vhost
>         git checkout 8a75f36b5d7a48f1c5a0b46638961c951ec6ecd9
>         # save the config file to linux build tree
>         mkdir build_dir
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=nios2 SHELL=/bin/bash
> 
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
> 
> All errors (new ones prefixed by >>):
> 
>    nios2-linux-ld: drivers/crypto/virtio/virtio_crypto_akcipher_algs.o: in function `virtio_crypto_rsa_set_key':
>    virtio_crypto_akcipher_algs.c:(.text+0x4bc): undefined reference to `rsa_parse_priv_key'
>    virtio_crypto_akcipher_algs.c:(.text+0x4bc): relocation truncated to fit: R_NIOS2_CALL26 against `rsa_parse_priv_key'
> >> nios2-linux-ld: virtio_crypto_akcipher_algs.c:(.text+0x4e8): undefined reference to `rsa_parse_pub_key'
>    virtio_crypto_akcipher_algs.c:(.text+0x4e8): relocation truncated to fit: R_NIOS2_CALL26 against `rsa_parse_pub_key'

I guess we need to select CRYPTO_RSA  ?

> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

