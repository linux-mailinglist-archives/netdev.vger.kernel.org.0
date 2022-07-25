Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BD7257FCB7
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 11:52:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231425AbiGYJwO convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 25 Jul 2022 05:52:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232747AbiGYJwL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 05:52:11 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A70214029;
        Mon, 25 Jul 2022 02:52:10 -0700 (PDT)
Received: from fraeml712-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4LrwGL3BCDz67Q5R;
        Mon, 25 Jul 2022 17:48:26 +0800 (CST)
Received: from fraeml714-chm.china.huawei.com (10.206.15.33) by
 fraeml712-chm.china.huawei.com (10.206.15.61) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 25 Jul 2022 11:52:07 +0200
Received: from fraeml714-chm.china.huawei.com ([10.206.15.33]) by
 fraeml714-chm.china.huawei.com ([10.206.15.33]) with mapi id 15.01.2375.024;
 Mon, 25 Jul 2022 11:52:07 +0200
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "Jesper Dangaard Brouer" <brouer@redhat.com>,
        =?iso-8859-1?Q?Toke_H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: RE: [PATCH bpf-next v7 04/13] bpf: Add support for forcing kfunc args
 to be trusted
Thread-Topic: [PATCH bpf-next v7 04/13] bpf: Add support for forcing kfunc
 args to be trusted
Thread-Index: AQHYnQf5YGGK69PM90+FORw5bILjSq2O3aig
Date:   Mon, 25 Jul 2022 09:52:07 +0000
Message-ID: <64f5b92546c14b69a20e9007bb31146b@huawei.com>
References: <20220721134245.2450-1-memxor@gmail.com>
 <20220721134245.2450-5-memxor@gmail.com>
In-Reply-To: <20220721134245.2450-5-memxor@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.221.98.153]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Kumar Kartikeya Dwivedi [mailto:memxor@gmail.com]
> Sent: Thursday, July 21, 2022 3:43 PM
> Teach the verifier to detect a new KF_TRUSTED_ARGS kfunc flag, which
> means each pointer argument must be trusted, which we define as a
> pointer that is referenced (has non-zero ref_obj_id) and also needs to
> have its offset unchanged, similar to how release functions expect their
> argument. This allows a kfunc to receive pointer arguments unchanged
> from the result of the acquire kfunc.
> 
> This is required to ensure that kfunc that operate on some object only
> work on acquired pointers and not normal PTR_TO_BTF_ID with same type
> which can be obtained by pointer walking. The restrictions applied to
> release arguments also apply to trusted arguments. This implies that
> strict type matching (not deducing type by recursively following members
> at offset) and OBJ_RELEASE offset checks (ensuring they are zero) are
> used for trusted pointer arguments.
> 
> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> ---
>  include/linux/btf.h | 32 ++++++++++++++++++++++++++++++++
>  kernel/bpf/btf.c    | 17 ++++++++++++++---
>  net/bpf/test_run.c  |  5 +++++
>  3 files changed, 51 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/btf.h b/include/linux/btf.h
> index 6dfc6eaf7f8c..cb63aa71e82f 100644
> --- a/include/linux/btf.h
> +++ b/include/linux/btf.h
> @@ -17,6 +17,38 @@
>  #define KF_RELEASE	(1 << 1) /* kfunc is a release function */
>  #define KF_RET_NULL	(1 << 2) /* kfunc returns a pointer that may be NULL */
>  #define KF_KPTR_GET	(1 << 3) /* kfunc returns reference to a kptr */
> +/* Trusted arguments are those which are meant to be referenced arguments
> with
> + * unchanged offset. It is used to enforce that pointers obtained from acquire
> + * kfuncs remain unmodified when being passed to helpers taking trusted args.
> + *
> + * Consider
> + *	struct foo {
> + *		int data;
> + *		struct foo *next;
> + *	};
> + *
> + *	struct bar {
> + *		int data;
> + *		struct foo f;
> + *	};
> + *
> + *	struct foo *f = alloc_foo(); // Acquire kfunc
> + *	struct bar *b = alloc_bar(); // Acquire kfunc
> + *
> + * If a kfunc set_foo_data() wants to operate only on the allocated object, it
> + * will set the KF_TRUSTED_ARGS flag, which will prevent unsafe usage like:
> + *
> + *	set_foo_data(f, 42);	   // Allowed
> + *	set_foo_data(f->next, 42); // Rejected, non-referenced pointer
> + *	set_foo_data(&f->next, 42);// Rejected, referenced, but bad offset
> + *	set_foo_data(&b->f, 42);   // Rejected, referenced, but wrong type
> + *
> + * In the final case, usually for the purposes of type matching, it is deduced
> + * by looking at the type of the member at the offset, but due to the
> + * requirement of trusted argument, this deduction will be strict and not done
> + * for this case.
> + */
> +#define KF_TRUSTED_ARGS (1 << 4) /* kfunc only takes trusted pointer
> arguments */

Hi Kumar

would it make sense to introduce per-parameter flags? I have a function
that has several parameters, but only one is referenced.

Thanks

Roberto
