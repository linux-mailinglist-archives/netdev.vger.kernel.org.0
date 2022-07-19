Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE8BC57A0A6
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 16:08:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238726AbiGSOIh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 10:08:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237728AbiGSOIB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 10:08:01 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24C8353D24;
        Tue, 19 Jul 2022 06:24:42 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id t3so19613180edd.0;
        Tue, 19 Jul 2022 06:24:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=G22xpv+7ScEDhIYUw4SP7yseZ38Q6eJDEsWNGUmx+GA=;
        b=BKhC5x7NE08GQnVKJtbrLPEWaRJCntJV2VoDonj1O8upS29joRfSqU+QaQno4qj+M3
         Lgg559VwCni47VncsRFPuQpSUDjJ3Y0eED1Dyd/EroTRKw3QiLfpCbIUPHakVSAZWBX0
         YnERVKQaUOHsTzFIkLlLw4AsLAF9lww+R0zynAT4KvhuzB7ugoVe7LBUmBrzheAqNhyX
         BTI4X0l4LF2fTVHfy4W6lNfiq02Oepzn6RrsNXsmuG6TRhiJQaGbSjtI2/NH9KaaBUld
         G3XwwTtZHpfywUEMAww0ZFrTrwLJlZQfda74/KzHmIv1nHpl5U4nk2rDwa5qcgoBzMPp
         bM3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=G22xpv+7ScEDhIYUw4SP7yseZ38Q6eJDEsWNGUmx+GA=;
        b=snM1GsDKFPfiTBPSbu64rvv3mv82XiX3sJvyHCs/8KwMXDdpL53hdXZE5tNp3NWDdf
         fEFySsijzIRzrpjW3zG4Vyg+sBN8yzFIzKiMUq0pwqvLMz5IOHYThtUaFupKxWTDiDWt
         cYEDN9wDk24A6Hh0q/L4l5QMX9DpMHQOKOLkK6X+0IMZ/V7cPDLFliwG/jTtRpeSoU/x
         faZmB/65G9k2Zhoud9gt17Tc6cPfMT+r8jrvM8tElqrnfXjQsydyQwW7nDJQmUvo8vJO
         f3hYmNB+X7eOCXiWqpepejKLTAglNmMMSJwSCC1BK+gqktLTIc2Uw6VBh0pXXSX9BSNN
         4eVw==
X-Gm-Message-State: AJIora8Uk7f+d2Xbe8zc7wIyPz9vlCkRpmpGyB78bGM0n2O6bwP/jeEC
        KfH+bXBNxnXZlMtXYUq12DPLhpdrBwAWyg==
X-Google-Smtp-Source: AGRyM1unZTFpqZwM2x8aZ/4SG0FU4oyJXQ/9kWa2BdrzNO4cUzmDAZK+JUSt1OKm9M5ebLt953nDug==
X-Received: by 2002:a05:6402:2689:b0:43a:dc35:11bb with SMTP id w9-20020a056402268900b0043adc3511bbmr45452922edd.262.1658237080258;
        Tue, 19 Jul 2022 06:24:40 -0700 (PDT)
Received: from localhost (icdhcp-1-189.epfl.ch. [128.178.116.189])
        by smtp.gmail.com with ESMTPSA id w6-20020a50fa86000000b0043ba0cf5dbasm722537edr.2.2022.07.19.06.24.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 06:24:39 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     KP Singh <kpsingh@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Subject: [PATCH bpf-next v6 05/13] bpf: Add documentation for kfuncs
Date:   Tue, 19 Jul 2022 15:24:22 +0200
Message-Id: <20220719132430.19993-6-memxor@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220719132430.19993-1-memxor@gmail.com>
References: <20220719132430.19993-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=8492; i=memxor@gmail.com; h=from:subject; bh=sYJ45Q+Q8+3BI/qToQ39EWKrf40MpcxF1MZ4RoM2D10=; b=owEBbQKS/ZANAwAKAUzgyIZIvxHKAcsmYgBi1rBlHGsWeQg5Y8yO30RIYASAeTG/lgRiDlAphKZ9 Ib9oez+JAjMEAAEKAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYtawZQAKCRBM4MiGSL8RypuEEA CsJaLP9BK77DuoHXUl5LrB6TVzu1jBqesuJOU8hpo8N1PTSYUkyg7Xa0x9ns908OdfLOGP9iLv6z17 k65XoUdu+u8UOmbBBwiUu7aht5XcOX4/u9dKUnHh+X0tHC7T4OHXihlwS4M/1kE3lTSV+dETkXz+6h PdCrplTUEIFUIeLx3L68w4YNKmQIWklw1qDhjH6pLfrjNssVJJ34fipW09i8NZhYnXqB9TUFyz5zGn 3KCvF0EzTKR9oDXuTzSRQixehNosJrT/V0bbWa6PRSOTaLAiqZuquKpKoWNCp/GA+All2IOtPVTYpC gaH+tCph3Mvarb8euP5vcCkyxdL0+EJBZ8SSeNT684trFmGVlP9tncSgLc7FcsnvAE54Fe8mGSkBfB mbvp/Cmia1VOHiWvvqxb+PV6jrr8qxRWDNgr969hJzIu42tp3IaX42j5yuO/c848Q9VfG6dDxbHjOF mu5+cy8qVFtDdALU94jL3IRpgITC4r27VPrTFD1TlhTsyghKhCgen1Iv2zUAG+HMHvGEeSvwZudG5C YdHK5rRTKBB3JPqpelcUGvwaF39gcNeAXPtBIOcREkR4xmP0BcPKu15cMOvOFWudTY9TEqKTeVR+EN MymNXdBLcDnut9HHu7HW4IvXwaWtOzKvqDB644T2LvcAdKepbKwQ/vxwdvLw==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As the usage of kfuncs grows, we are starting to form consensus on the
kinds of attributes and annotations that kfuncs can have. To better help
developers make sense of the various options available at their disposal
to present an unstable API to the BPF users, document the various kfunc
flags and annotations, their expected usage, and explain the process of
defining and registering a kfunc set.

Cc: KP Singh <kpsingh@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 Documentation/bpf/index.rst  |   1 +
 Documentation/bpf/kfuncs.rst | 171 +++++++++++++++++++++++++++++++++++
 2 files changed, 172 insertions(+)
 create mode 100644 Documentation/bpf/kfuncs.rst

diff --git a/Documentation/bpf/index.rst b/Documentation/bpf/index.rst
index 96056a7447c7..1bc2c5c58bdb 100644
--- a/Documentation/bpf/index.rst
+++ b/Documentation/bpf/index.rst
@@ -19,6 +19,7 @@ that goes into great technical depth about the BPF Architecture.
    faq
    syscall_api
    helpers
+   kfuncs
    programs
    maps
    bpf_prog_run
diff --git a/Documentation/bpf/kfuncs.rst b/Documentation/bpf/kfuncs.rst
new file mode 100644
index 000000000000..cc6390b1e9d7
--- /dev/null
+++ b/Documentation/bpf/kfuncs.rst
@@ -0,0 +1,171 @@
+=============================
+BPF Kernel Functions (kfuncs)
+=============================
+
+1. Introduction
+===============
+
+BPF Kernel Functions or more commonly known as kfuncs are functions in the Linux
+kernel which are exposed for use by BPF programs. Unlike normal BPF helpers,
+kfuncs do not have a stable interface and can change from one kernel release to
+another. Hence, BPF programs need to be updated in response to changes in the
+kernel.
+
+2. Defining a kfunc
+===================
+
+There are two ways to expose a kernel function to BPF programs, either make an
+existing function in the kernel visible, or add a new wrapper for BPF. In both
+cases, care must be taken that BPF program can only call such function in a
+valid context. To enforce this, visibility of a kfunc can be per program type.
+
+If you are not creating a BPF wrapper for existing kernel function, skip ahead
+to :ref:`BPF_kfunc_nodef`.
+
+2.1 Creating a wrapper kfunc
+----------------------------
+
+When defining a wrapper kfunc, the wrapper function should have extern linkage.
+This prevents the compiler from optimizing away dead code, as this wrapper kfunc
+is not invoked anywhere in the kernel itself. It is not necessary to provide a
+prototype in a header for the wrapper kfunc.
+
+An example is given below::
+
+        /* Disables missing prototype warnings */
+        __diag_push();
+        __diag_ignore_all("-Wmissing-prototypes",
+                          "Global kfuncs as their definitions will be in BTF");
+
+        struct task_struct *bpf_find_get_task_by_vpid(pid_t nr)
+        {
+                return find_get_task_by_vpid(nr);
+        }
+
+        __diag_pop();
+
+A wrapper kfunc is often needed when we need to annotate parameters of the
+kfunc. Otherwise one may directly make the kfunc visible to the BPF program by
+registering it with the BPF subsystem. See :ref:`BPF_kfunc_nodef`.
+
+2.2 Annotating kfunc parameters
+-------------------------------
+
+Similar to BPF helpers, there is sometime need for additional context required
+by the verifier to make the usage of kernel functions safer and more useful.
+Hence, we can annotate a parameter by suffixing the name of the argument of the
+kfunc with a __tag, where tag may be one of the supported annotations.
+
+2.2.1 __sz Annotation
+---------------------
+
+This annotation is used to indicate a memory and size pair in the argument list.
+An example is given below::
+
+        void bpf_memzero(void *mem, int mem__sz)
+        {
+        ...
+        }
+
+Here, the verifier will treat first argument as a PTR_TO_MEM, and second
+argument as its size. By default, without __sz annotation, the size of the type
+of the pointer is used. Without __sz annotation, a kfunc cannot accept a void
+pointer.
+
+.. _BPF_kfunc_nodef:
+
+2.3 Using an existing kernel function
+-------------------------------------
+
+When an existing function in the kernel is fit for consumption by BPF programs,
+it can be directly registered with the BPF subsystem. However, care must still
+be taken to review the context in which it will be invoked by the BPF program
+and whether it is safe to do so.
+
+2.4 Annotating kfuncs
+---------------------
+
+In addition to kfuncs' arguments, verifier may need more information about the
+type of kfunc(s) being registered with the BPF subsystem. To do so, we define
+flags on a set of kfuncs as follows::
+
+        BTF_SET8_START(bpf_task_set)
+        BTF_ID_FLAGS(func, bpf_get_task_pid, KF_ACQUIRE, KF_RET_NULL)
+        BTF_ID_FLAGS(func, bpf_put_pid, KF_RELEASE)
+        BTF_SET8_END(bpf_task_set)
+
+This set encodes the BTF ID of each kfunc listed above, and encodes the flags
+along with it. Ofcourse, it is also allowed to specify no flags. The flags are
+passed as a list of arguments to BTF_ID_FLAGS macro.
+
+2.4.1 KF_ACQUIRE flag
+---------------------
+
+The KF_ACQUIRE flag is used to indicate that the kfunc returns a pointer to a
+refcounted object. The verifier will then ensure that the pointer to the object
+is eventually released using a release kfunc, or transferred to a map using a
+referenced kptr (by invoking bpf_kptr_xchg). If not, the verifier fails the
+loading of the BPF program until no lingering references remain in all possible
+explored states of the program.
+
+2.4.2 KF_RET_NULL flag
+----------------------
+
+The KF_RET_NULL flag is used to indicate that the pointer returned by the kfunc
+may be NULL. Hence, it forces the user to do a NULL check on the pointer
+returned from the kfunc before making use of it (dereferencing or passing to
+another helper). This flag is often used in pairing with KF_ACQUIRE flag, but
+both are mutually exclusive.
+
+2.4.3 KF_RELEASE flag
+---------------------
+
+The KF_RELEASE flag is used to indicate that the kfunc releases the pointer
+passed in to it. There can be only one referenced pointer that can be passed in.
+All copies of the pointer being released are invalidated as a result of invoking
+kfunc with this flag.
+
+2.4.4 KF_KPTR_GET flag
+----------------------
+
+The KF_KPTR_GET flag is used to indicate that the kfunc takes the first argument
+as a pointer to kptr, safely increments the refcount of the object it points to,
+and returns a reference to the user. The rest of the arguments may be normal
+arguments of a kfunc. The KF_KPTR_GET flag should be used in conjunction with
+KF_ACQUIRE and KF_RET_NULL flags.
+
+2.4.5 KF_TRUSTED_ARGS flag
+--------------------------
+
+The KF_TRUSTED_ARGS flag is used for kfuncs taking pointer arguments. It
+indicates that the all pointer arguments will always be refcounted, and have
+their offset set to 0. It can be used to enforce that a pointer to a refcounted
+object acquired from a kfunc or BPF helper is passed as an argument to this
+kfunc without any modifications (e.g. pointer arithmetic) such that it is
+trusted and points to the original object. This flag is often used for kfuncs
+that operate (change some property, perform some operation) on an object that
+was obtained using an acquire kfunc. Such kfuncs need an unchanged pointer to
+ensure the integrity of the operation being performed on the expected object.
+
+2.5 Registering the kfuncs
+--------------------------
+
+Once the kfunc is prepared for use, the final step to making it visible is
+registering it with the BPF subsystem. Registration is done per BPF program
+type. An example is shown below::
+
+        BTF_SET8_START(bpf_task_set)
+        BTF_ID_FLAGS(func, bpf_get_task_pid, KF_ACQUIRE, KF_RET_NULL)
+        BTF_ID_FLAGS(func, bpf_put_pid, KF_RELEASE)
+        BTF_SET8_END(bpf_task_set)
+
+        static const struct btf_kfunc_id_set bpf_task_kfunc_set = {
+                .owner = THIS_MODULE,
+                .set   = &bpf_task_set,
+        };
+
+        static int init_subsystem(void)
+        {
+                return register_btf_kfunc_id_set(BPF_PROG_TYPE_TRACING, &bpf_task_kfunc_set);
+        }
+        late_initcall(init_subsystem);
-- 
2.34.1

