Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7385C4196EB
	for <lists+netdev@lfdr.de>; Mon, 27 Sep 2021 17:00:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234981AbhI0PBe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 11:01:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234833AbhI0PBb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Sep 2021 11:01:31 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA36DC061769;
        Mon, 27 Sep 2021 07:59:52 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id 75so1675269pga.3;
        Mon, 27 Sep 2021 07:59:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YC/5g23SPpiZ7A5VfOJx+Ff2nYKoj2UfUfHHpa2IJDY=;
        b=YlW+cCsID+sm/E9I595RTis9Dyr9U/qkj7DwYq4bUEj0tJAz8cY4SHwJlbjm3VDda4
         NTHbAcbER6Qtba6xM3kzPg79PYtVePhEn7zkheSPYJ+o7DSMw/EKyJONn/vi7RS0gOsU
         rWnWH89blEKxHIYvm9NonJCvUahF9mNJ9tatGIsMoJ6pkkXQeylVVpOojoGL3fwaKWkD
         e/00oNqlNqcaT3ycueM35ZxDTgxzAyidl00kDKaO4k3tsSyeqwq1lvm/Qvdo5Yl7s74b
         YuNGFni9nxpsDPcMySibOdSiH/PKcBOd2Xwh4DerCLiDoFn7QFWOhqHMMYyI5lsnJqsp
         LBPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YC/5g23SPpiZ7A5VfOJx+Ff2nYKoj2UfUfHHpa2IJDY=;
        b=Z0p/2JxD83nIHgeKqcBtxXrvfNMWm+eOOKTvzy+4EZwrgH9ythZfCqjLtY+HTG+/T/
         y0Cp5Mmqm/Xou/9vBfFWtqq7Owo2ltfqZwnYIxCNNHFoGYC+aeQFzOmYbFVbQB8r0Xl4
         RH9KNdbtOuNZ8fBrsToXBwr376SxbBCyO3U+BsqGK2O8Hl25gvcNdbLVoY55jgi3i9tG
         j691dSgANnIDTl3q5dMVRaNSn5nFCUdyHr+pYgn2Sgj+m1S5HeALpQ98x1q6oE0wzAL5
         OeSElxUotbLGG41si/a5kHiB7YNjtEa5iTYAIjbv6/tibCs+AA3W0MDf4bPJdoWS4Tq4
         Tgiw==
X-Gm-Message-State: AOAM531yR4kcOgE2OXUPMAxvtWtLWZ0ZNT0xk+Ne9fFCw10rRKhiN04T
        DVQczzeFrGKhs28xaGSDX4xYmSlciqg=
X-Google-Smtp-Source: ABdhPJxDVlyE5OpEzOeh0phQc3G4ubss858xwIQYonUw079dBQLBRg9mmzVOSkEoGyI8bqVIJlcbqg==
X-Received: by 2002:a65:6658:: with SMTP id z24mr134892pgv.266.1632754792171;
        Mon, 27 Sep 2021 07:59:52 -0700 (PDT)
Received: from localhost ([2405:201:6014:d058:a28d:3909:6ed5:29e7])
        by smtp.gmail.com with ESMTPSA id mt17sm16244745pjb.38.2021.09.27.07.59.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Sep 2021 07:59:51 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next v5 02/12] bpf: Be conservative while processing invalid kfunc calls
Date:   Mon, 27 Sep 2021 20:29:31 +0530
Message-Id: <20210927145941.1383001-3-memxor@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927145941.1383001-1-memxor@gmail.com>
References: <20210927145941.1383001-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2214; h=from:subject; bh=FKRyNZlxBXZubpWKuL4SYjb1veTjvmV2mok2OrudHXU=; b=owEBbAKT/ZANAwAIAUzgyIZIvxHKAcsmYgBhUdxOvRD+YlTis4ZpxqZMjImP98Z2FoCqLKhYqPfs a52iZuSJAjIEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYVHcTgAKCRBM4MiGSL8Ryn3fD/ jUltPQyOQmSBE2DmxdqSSaXYt41MY+KG12tZNCADyi7SNqzKvpmarEUVp+SX1ddUAfjSDyPKRe8j2U GMhjw2a2npffhD+fFf5wxZSpA3s53J76Egc61rHTY48YCb4hT/qLc3nnE+5cZFGk4WrJgwOAM01eFJ aNQic5d20p0Kni1RKk/krxsRKxdS9IhTz9IQ76Ufm+/y3nh2k/gWPicyOyjGFAv5mF07ag8cvOO6Fu oL8Iawvb6zgvuwtE553e8r9N/Cn1a+4p1j6yWd8bSJlD5GZH5i2YoqJo84jBXkneA5TAOw0VVm6X7Z fGb1OkuXphAM8HMSdDntQfCi50JWzxXy22cu020otE7DUwa8Wb6Pg8JOWB/iW1LkfQUpzt2ycmiktv qAnlAk2JXW8fxXSNhrfzhp/YKFiV5suwEJZMl7oHUugAIF0TWjkPRlsNdC5NEoNBGlT8BtksZK/rAb f2OaTHw8BXJ1DzlWu+pqkn3rTHlOiUJk0TRjX7dTUeIRA20sNCvAABVH6Pnl7f89F2aS3iciuUlaL7 REInb7Qnw+b1TBwibrOL69Dx8GkqQzh2/XGeGTBdGIhQa6wK1noHXOQxGqY+7jFw63u1r6p+DU4zQD GxfxsMuIyRwhInr4eHzCVQ0MqKOO59ShhFVxslknIC03kic9xxcUy/2c3b
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch also modifies the BPF verifier to only return error for
invalid kfunc calls specially marked by userspace (with insn->imm == 0,
insn->off == 0) after the verifier has eliminated dead instructions.
This can be handled in the fixup stage, and skip processing during add
and check stages.

If such an invalid call is dropped, the fixup stage will not encounter
insn->imm as 0, otherwise it bails out and returns an error.

This will be exposed as weak ksym support in libbpf in later patches.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 kernel/bpf/verifier.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 5b465d67cf65..58c86670dc55 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -1820,6 +1820,15 @@ static int add_kfunc_call(struct bpf_verifier_env *env, u32 func_id, s16 offset)
 		prog_aux->kfunc_tab = tab;
 	}
 
+	/* func_id == 0 is always invalid, but instead of returning an error, be
+	 * conservative and wait until the code elimination pass before returning
+	 * error, so that invalid calls that get pruned out can be in BPF programs
+	 * loaded from userspace.  It is also required that offset be untouched
+	 * for such calls.
+	 */
+	if (!func_id && !offset)
+		return 0;
+
 	if (!btf_tab && offset) {
 		btf_tab = kzalloc(sizeof(*btf_tab), GFP_KERNEL);
 		if (!btf_tab)
@@ -6630,6 +6639,10 @@ static int check_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn)
 	struct btf *desc_btf;
 	int err;
 
+	/* skip for now, but return error when we find this in fixup_kfunc_call */
+	if (!insn->imm)
+		return 0;
+
 	desc_btf = find_kfunc_desc_btf(env, insn->imm, insn->off, &btf_mod);
 	if (IS_ERR(desc_btf))
 		return PTR_ERR(desc_btf);
@@ -12766,6 +12779,11 @@ static int fixup_kfunc_call(struct bpf_verifier_env *env,
 {
 	const struct bpf_kfunc_desc *desc;
 
+	if (!insn->imm) {
+		verbose(env, "invalid kernel function call not eliminated in verifier pass\n");
+		return -EINVAL;
+	}
+
 	/* insn->imm has the btf func_id. Replace it with
 	 * an address (relative to __bpf_base_call).
 	 */
-- 
2.33.0

