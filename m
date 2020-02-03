Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04EE71510FD
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 21:27:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726474AbgBCU1o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 15:27:44 -0500
Received: from mga09.intel.com ([134.134.136.24]:30955 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726272AbgBCU1o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Feb 2020 15:27:44 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Feb 2020 12:27:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,398,1574150400"; 
   d="scan'208";a="224401985"
Received: from asubram1-mobl1.ger.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.249.38.99])
  by fmsmga007.fm.intel.com with ESMTP; 03 Feb 2020 12:27:40 -0800
Subject: Re: [PATCH 5/5] bpf: Allow to resolve bpf trampoline in unwind
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Andrii Nakryiko <andriin@fb.com>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        David Miller <davem@redhat.com>
References: <20191229143740.29143-1-jolsa@kernel.org>
 <20191229143740.29143-6-jolsa@kernel.org>
 <20200106234639.fo2ctgkb5vumayyl@ast-mbp> <20200107130546.GI290055@krava>
 <76a10338-391a-ffca-9af8-f407265d146a@intel.com>
 <20200113094310.GE35080@krava>
 <a2e2b84e-71dd-e32c-bcf4-09298e9f4ce7@intel.com>
 <9da1c8f9-7ca5-e10b-8931-6871fdbffb23@intel.com>
 <20200113123728.GA120834@krava> <20200203195826.GB1535545@krava>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <8f656ce1-c350-0edd-096b-8f1c395609ec@intel.com>
Date:   Mon, 3 Feb 2020 21:27:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200203195826.GB1535545@krava>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-02-03 20:58, Jiri Olsa wrote:
[...]
>>> ...and FWIW, it would be nice with bpf_dispatcher_<...> entries in kallsyms
>>
>> ok so it'd be 'bpf_dispatcher_<name>'
> 
> hi,
> so the only dispatcher is currently defined as:
>    DEFINE_BPF_DISPATCHER(bpf_dispatcher_xdp)
> 
> with the bpf_dispatcher_<name> logic it shows in kallsyms as:
>    ffffffffa0450000 t bpf_dispatcher_bpf_dispatcher_xdp    [bpf]
>

Ick! :-P


> to fix that, would you guys preffer having:
>    DEFINE_BPF_DISPATCHER(xdp)
> 
> or using the full dispatcher name as kallsyms name?
> which would require some discipline for future dispatcher names ;-)
>

I'd prefer the latter, i.e. name "xdp" is shown as bpf_dispatcher_xdp in 
kallsyms.

...and if this route is taken, the macros can be changed, so that the 
trampoline functions are prefixed with "bpf_dispatcher_". Something like 
this (and also a small '_' cleanup):


diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 8e9ad3943cd9..15c5f351f837 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -512,7 +512,7 @@ struct bpf_dispatcher {
  	u32 image_off;
  };

-static __always_inline unsigned int bpf_dispatcher_nopfunc(
+static __always_inline unsigned int bpf_dispatcher_nop_func(
  	const void *ctx,
  	const struct bpf_insn *insnsi,
  	unsigned int (*bpf_func)(const void *,
@@ -527,7 +527,7 @@ int bpf_trampoline_unlink_prog(struct bpf_prog *prog);
  void bpf_trampoline_put(struct bpf_trampoline *tr);
  #define BPF_DISPATCHER_INIT(name) {			\
  	.mutex = __MUTEX_INITIALIZER(name.mutex),	\
-	.func = &name##func,				\
+	.func = &name##_func,				\
  	.progs = {},					\
  	.num_progs = 0,					\
  	.image = NULL,					\
@@ -535,7 +535,7 @@ void bpf_trampoline_put(struct bpf_trampoline *tr);
  }

  #define DEFINE_BPF_DISPATCHER(name)					\
-	noinline unsigned int name##func(				\
+	noinline unsigned int bpf_dispatcher_##name##_func(		\
  		const void *ctx,					\
  		const struct bpf_insn *insnsi,				\
  		unsigned int (*bpf_func)(const void *,			\
@@ -543,17 +543,18 @@ void bpf_trampoline_put(struct bpf_trampoline *tr);
  	{								\
  		return bpf_func(ctx, insnsi);				\
  	}								\
-	EXPORT_SYMBOL(name##func);			\
-	struct bpf_dispatcher name = BPF_DISPATCHER_INIT(name);
+	EXPORT_SYMBOL(bpf_dispatcher_##name##_func);			\
+	struct bpf_dispatcher bpf_dispatcher_##name =			\
+		BPF_DISPATCHER_INIT(bpf_dispatcher_##name);
  #define DECLARE_BPF_DISPATCHER(name)					\
-	unsigned int name##func(					\
+	unsigned int bpf_dispatcher_##name##_func(			\
  		const void *ctx,					\
  		const struct bpf_insn *insnsi,				\
  		unsigned int (*bpf_func)(const void *,			\
  					 const struct bpf_insn *));	\
-	extern struct bpf_dispatcher name;
-#define BPF_DISPATCHER_FUNC(name) name##func
-#define BPF_DISPATCHER_PTR(name) (&name)
+	extern struct bpf_dispatcher bpf_dispatcher_##name;
+#define BPF_DISPATCHER_FUNC(name) bpf_dispatcher_##name##_func
+#define BPF_DISPATCHER_PTR(name) (&bpf_dispatcher_##name)
  void bpf_dispatcher_change_prog(struct bpf_dispatcher *d, struct 
bpf_prog *from,
  				struct bpf_prog *to);
  struct bpf_image {
@@ -579,7 +580,7 @@ static inline int bpf_trampoline_unlink_prog(struct 
bpf_prog *prog)
  static inline void bpf_trampoline_put(struct bpf_trampoline *tr) {}
  #define DEFINE_BPF_DISPATCHER(name)
  #define DECLARE_BPF_DISPATCHER(name)
-#define BPF_DISPATCHER_FUNC(name) bpf_dispatcher_nopfunc
+#define BPF_DISPATCHER_FUNC(name) bpf_dispatcher_nop_func
  #define BPF_DISPATCHER_PTR(name) NULL
  static inline void bpf_dispatcher_change_prog(struct bpf_dispatcher *d,
  					      struct bpf_prog *from,
diff --git a/include/linux/filter.h b/include/linux/filter.h
index f349e2c0884c..eafe72644282 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -577,7 +577,7 @@ DECLARE_STATIC_KEY_FALSE(bpf_stats_enabled_key);
  	ret; })

  #define BPF_PROG_RUN(prog, ctx) __BPF_PROG_RUN(prog, ctx,		\
-					       bpf_dispatcher_nopfunc)
+					       bpf_dispatcher_nop_func)

  #define BPF_SKB_CB_LEN QDISC_CB_PRIV_LEN

@@ -701,7 +701,7 @@ static inline u32 bpf_prog_run_clear_cb(const struct 
bpf_prog *prog,
  	return res;
  }

-DECLARE_BPF_DISPATCHER(bpf_dispatcher_xdp)
+DECLARE_BPF_DISPATCHER(xdp)

  static __always_inline u32 bpf_prog_run_xdp(const struct bpf_prog *prog,
  					    struct xdp_buff *xdp)
@@ -712,8 +712,7 @@ static __always_inline u32 bpf_prog_run_xdp(const 
struct bpf_prog *prog,
  	 * already takes rcu_read_lock() when fetching the program, so
  	 * it's not necessary here anymore.
  	 */
-	return __BPF_PROG_RUN(prog, xdp,
-			      BPF_DISPATCHER_FUNC(bpf_dispatcher_xdp));
+	return __BPF_PROG_RUN(prog, xdp, BPF_DISPATCHER_FUNC(xdp));
  }

  void bpf_prog_change_xdp(struct bpf_prog *prev_prog, struct bpf_prog 
*prog);
diff --git a/net/core/filter.c b/net/core/filter.c
index 792e3744b915..5db435141e16 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -8835,10 +8835,9 @@ const struct bpf_prog_ops sk_reuseport_prog_ops = {
  };
  #endif /* CONFIG_INET */

-DEFINE_BPF_DISPATCHER(bpf_dispatcher_xdp)
+DEFINE_BPF_DISPATCHER(xdp)

  void bpf_prog_change_xdp(struct bpf_prog *prev_prog, struct bpf_prog 
*prog)
  {
-	bpf_dispatcher_change_prog(BPF_DISPATCHER_PTR(bpf_dispatcher_xdp),
-				   prev_prog, prog);
+	bpf_dispatcher_change_prog(BPF_DISPATCHER_PTR(xdp), prev_prog, prog);
  }
