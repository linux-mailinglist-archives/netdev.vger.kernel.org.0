Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF6349A2AE
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 00:16:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393795AbfHVWPl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 18:15:41 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:44981 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390161AbfHVWPk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 18:15:40 -0400
Received: by mail-qk1-f194.google.com with SMTP id d79so6561698qke.11
        for <netdev@vger.kernel.org>; Thu, 22 Aug 2019 15:15:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=BbaansFyYpgSkEUevWawcki/DYsOwVLKXxn4fVQ1MuY=;
        b=KzQ6u/7+muvA7/ORJDSKOAuSfhDCCN136LYuv3/nfRScBROgWTAj4CPkwmWiKULToL
         Cn1kcj6jiO4tIOVIWLlotADrEXSQRWXoR38VsVacjuAR6G1UOk6J1oLHnm39/WTfq18r
         umqKNH2aUPYmudohuA3Lt6a4HxzAvKaVhSiZfHmAnPg40L3knYG2QdESt6w2tShnYK0l
         XROYHOqjA/O2WzfmBGLSpu+xlv6r275UebQ8fWMODylb90sM1RhOJJW8XvRcjMSc6KbC
         7Zkxci6dfI2S5yB2lui9maFVzQmBLs5cuRzyJBIx23uwT3IdIChjJ1H1ykqBNyk3wWDH
         jPmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=BbaansFyYpgSkEUevWawcki/DYsOwVLKXxn4fVQ1MuY=;
        b=N1YMMJ7SP0V8PkZ3LoxGWQR0d9T9xyN9CJaKVcJp13/HSwp0BgElpuBOFp1TPETsDw
         rT1IrEHzRLq33aNiQxbXQgpa1Gex3O3gs31vYMZpE8hvAkiW02EmZD3HDoEf8rfc/3+2
         OZqHqhaIf1nAOwHung7JNOQsa1QHAp+BN7ql4eP2eZfOgpc6Yj7Yil/E0ZIXRHLvdFMh
         iAMYheLLkJADn2M6/gzI2UUn90xzrAqqwcn5Dmz4GKJWaFQoGc6cweHW7jZrChOmUeV9
         kf/TokBQiLGaMRPP/LnGdLSN8kREhwncvy2ozVd1Yr59N+z+gysD8aysotAK/PZbvfxh
         aUhg==
X-Gm-Message-State: APjAAAUkH3xCOrWgvCBoVc/wJn86FwgtLY6de0fnS5dmb/euHMP33sVG
        iEue68QUDoOsE0AbntKeRFFXXw==
X-Google-Smtp-Source: APXvYqzJbByCMxo/VGnfPfDtAgepn6dRHqsg35d8nqdXbnW/L1LGfQ94xxW0qITiaCQAeDEwL/KfFQ==
X-Received: by 2002:a37:2c07:: with SMTP id s7mr1283773qkh.495.1566512139829;
        Thu, 22 Aug 2019 15:15:39 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id o45sm571743qta.65.2019.08.22.15.15.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Aug 2019 15:15:39 -0700 (PDT)
Date:   Thu, 22 Aug 2019 15:15:30 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Vlad Buslov <vladbu@mellanox.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, pablo@netfilter.org,
        Jiri Pirko <jiri@mellanox.com>
Subject: Re: [PATCH net-next 01/10] net: sched: protect block
 offload-related fields with rw_semaphore
Message-ID: <20190822151530.09f7ca04@cakuba.netronome.com>
In-Reply-To: <20190822124353.16902-2-vladbu@mellanox.com>
References: <20190822124353.16902-1-vladbu@mellanox.com>
        <20190822124353.16902-2-vladbu@mellanox.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 22 Aug 2019 15:43:44 +0300, Vlad Buslov wrote:
> @@ -2987,19 +3007,26 @@ int tc_setup_cb_call(struct tcf_block *block, enum tc_setup_type type,
>  	int ok_count = 0;
>  	int err;
>  
> +	down_read(&block->cb_lock);
>  	/* Make sure all netdevs sharing this block are offload-capable. */
> -	if (block->nooffloaddevcnt && err_stop)
> -		return -EOPNOTSUPP;
> +	if (block->nooffloaddevcnt && err_stop) {
> +		ok_count = -EOPNOTSUPP;
> +		goto errout;
> +	}
>  
>  	list_for_each_entry(block_cb, &block->flow_block.cb_list, list) {
>  		err = block_cb->cb(type, type_data, block_cb->cb_priv);
>  		if (err) {
> -			if (err_stop)
> -				return err;
> +			if (err_stop) {
> +				ok_count = err;
> +				goto errout;
> +			}
>  		} else {
>  			ok_count++;
>  		}
>  	}
> +errout:

Please name the labels with the first action they perform. Here:

err_unlock:

> +	up_read(&block->cb_lock);
>  	return ok_count;
