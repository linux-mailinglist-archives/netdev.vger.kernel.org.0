Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 406A36EAC3F
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 16:04:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230205AbjDUOEU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 10:04:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232409AbjDUOEQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 10:04:16 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1749E12C94;
        Fri, 21 Apr 2023 07:04:13 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id 5b1f17b1804b1-3f178da21b2so18873155e9.1;
        Fri, 21 Apr 2023 07:04:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682085851; x=1684677851;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=/JkY/FeqfwTDAzjXxUVYhCowPnsmEX10/IEq+wg7MfE=;
        b=QpENFjucaOlw2KifOgYNlMzj1R6fGc5j3TvUytKxrGPGAoahy/Fj/tgVHB6aabjJbl
         Qnrv88xinrWWeIBUdkumFK9RP/oiZP4D8gFc2O7toJ5t+Wz5UaQoECEzDs+gxSu0LeAt
         BQ25akAL3KslQ6rqP22HcYeCDapqeukOGgmFhrD29lqHR77i+yJXw0dy2QhZu4deQP59
         lkyGXgKYu+26krahG/ghthrzPF++o7dV0I2FaA0+kGkixK+/tTX46h9aY8ySITC1JQ2a
         /foYFl6blet1dL6WSRqnjZckzd5Yq4inylh257kXGaiIbTtmJZY3+pp6rXPslVn2VOWO
         nUOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682085851; x=1684677851;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/JkY/FeqfwTDAzjXxUVYhCowPnsmEX10/IEq+wg7MfE=;
        b=Lzp/MkXstKmQhcGncqae3oKVNQHOXw7WqGCCcUpV+FVfGadMr86LV9nqRRELSn56GI
         IcmyhsS1eBa5qZzGyR1fCAbMOHkOJDpHtRJ6bowKmT68tMiYJlUgu6GiNpKgzLq1yTm+
         dGlV1kBQX2hUNw2BmWcnh20U8g/dqKfMIncKm7cpFmS5IRmPxgvpjLamTnG0u6Lz/bDs
         zgvoePCNgH83kiUcrU/wb/U7zqDwUXCvDgurbcGLmMip9X8L8if9lSXFVYjZjTDsvoMp
         Bg21etPh8zjsz55ywCrGC7xRZxm4YOV15q1ruksdyUmM0wWhTl9ayU/FTpTbJf3mz41A
         1j3g==
X-Gm-Message-State: AAQBX9c/QYNL6Zba1Q/Z513IgY90VbKsYw41EuEO97zTw3ohk8rJyojo
        Nv7wJ8rZdwXAzT+azctKzKb4otYgLSk4kg==
X-Google-Smtp-Source: AKy350YvdG2+MkJ4I/8CBXtDo4ia88WDgX84WlPdD+aLhwqC+pphrwtwFnmr8Xza72H41BXxFtxh8A==
X-Received: by 2002:a7b:cd96:0:b0:3f1:8338:4b8c with SMTP id y22-20020a7bcd96000000b003f183384b8cmr1975559wmj.1.1682085851301;
        Fri, 21 Apr 2023 07:04:11 -0700 (PDT)
Received: from [192.168.1.95] (boundsly.muster.volia.net. [93.72.16.93])
        by smtp.gmail.com with ESMTPSA id l18-20020a05600c4f1200b003f07ef4e3e0sm11162181wmq.0.2023.04.21.07.04.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Apr 2023 07:04:10 -0700 (PDT)
Message-ID: <e46effcbb08ca80c490fba07e01c8d9da8a9fde4.camel@gmail.com>
Subject: Re: [PATCH bpf-next] bpf: Fix race between btf_put and btf_idr walk.
From:   Eduard Zingerman <eddyz87@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, martin.lau@kernel.org,
        fw@strlen.de, davemarchevsky@meta.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Date:   Fri, 21 Apr 2023 17:04:09 +0300
In-Reply-To: <20230421014901.70908-1-alexei.starovoitov@gmail.com>
References: <20230421014901.70908-1-alexei.starovoitov@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu1 
MIME-Version: 1.0
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2023-04-20 at 18:49 -0700, Alexei Starovoitov wrote:
> From: Alexei Starovoitov <ast@kernel.org>
>=20
> Florian and Eduard reported hard dead lock:
> [   58.433327]  _raw_spin_lock_irqsave+0x40/0x50
> [   58.433334]  btf_put+0x43/0x90
> [   58.433338]  bpf_find_btf_id+0x157/0x240
> [   58.433353]  btf_parse_fields+0x921/0x11c0
>=20
> This happens since btf->refcount can be 1 at the time of btf_put() and
> btf_put() will call btf_free_id() which will try to grab btf_idr_lock
> and will dead lock.
> Avoid the issue by doing btf_put() without locking.
>=20
> Reported-by: Florian Westphal <fw@strlen.de>
> Reported-by: Eduard Zingerman <eddyz87@gmail.com>
> Fixes: 3d78417b60fb ("bpf: Add bpf_btf_find_by_name_kind() helper.")
> Fixes: 1e89106da253 ("bpf: Add bpf_core_add_cands() and wire it into bpf_=
core_apply_relo_insn().")
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>

I applied the patch from Dave, that fixes address computation
in bpf_refcount_acquire_impl() and tested this patch using the
following reproducing script (to obtain a race between test module
unload and bpf_find_btf_id():

  for j in $(seq 1 100);
    do echo ">>>> $j <<<<";
    for i in $(seq 1 4); do (./test_progs --allow=3Drefcounted_kptr &); don=
e;
    sleep 1;
  done

W/o this patch I see dead locks, with this patch I don't see dead locks.

Tested-by: Eduard Zingerman <eddyz87@gmail.com>

> ---
>  kernel/bpf/btf.c | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
>=20
> diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> index a0887ee44e89..7db4ec125fbd 100644
> --- a/kernel/bpf/btf.c
> +++ b/kernel/bpf/btf.c
> @@ -577,8 +577,8 @@ static s32 bpf_find_btf_id(const char *name, u32 kind=
, struct btf **btf_p)
>  			*btf_p =3D btf;
>  			return ret;
>  		}
> -		spin_lock_bh(&btf_idr_lock);
>  		btf_put(btf);
> +		spin_lock_bh(&btf_idr_lock);
>  	}
>  	spin_unlock_bh(&btf_idr_lock);
>  	return ret;
> @@ -8354,12 +8354,10 @@ bpf_core_find_cands(struct bpf_core_ctx *ctx, u32=
 local_type_id)
>  		btf_get(mod_btf);
>  		spin_unlock_bh(&btf_idr_lock);
>  		cands =3D bpf_core_add_cands(cands, mod_btf, btf_nr_types(main_btf));
> -		if (IS_ERR(cands)) {
> -			btf_put(mod_btf);
> +		btf_put(mod_btf);
> +		if (IS_ERR(cands))
>  			return ERR_CAST(cands);
> -		}
>  		spin_lock_bh(&btf_idr_lock);
> -		btf_put(mod_btf);
>  	}
>  	spin_unlock_bh(&btf_idr_lock);
>  	/* cands is a pointer to kmalloced memory here if cands->cnt > 0

