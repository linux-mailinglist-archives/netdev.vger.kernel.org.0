Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C7641448A5
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 01:01:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728797AbgAVABO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 19:01:14 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:39554 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726780AbgAVABN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 19:01:13 -0500
Received: by mail-wr1-f66.google.com with SMTP id y11so5390954wrt.6
        for <netdev@vger.kernel.org>; Tue, 21 Jan 2020 16:01:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=OHaBdf9m1dDSgiWgOEcClSMTZD84LoHiqTmQD6cEaTs=;
        b=bV93vL/4fDzGXFO2JCLe7XSiny5jsOXP+1mc/RM3P5+9LAEdfRZ4M2qFZguvwNb7Xg
         9F1VYmZZ0XO1/g/fAbDib/KRX8L3WacCqQvO4UFl28J2h5N0x8RjEjQsbICjFSJoWwur
         dwzrNK6ji2knC+Pl++t+qqjSspXviqg+HIn8s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=OHaBdf9m1dDSgiWgOEcClSMTZD84LoHiqTmQD6cEaTs=;
        b=A2UPvf5SbewlvsdVY4I+lhyx67S8hlAcUVugzO7Rz6J+9ht/Og4SG7j3tukeznOlTU
         gLizGm3xEV15ZTgxBNy3fljLWzFji/prAmclmCDjM5ddGyGh28rMtsXvknSqjF5fPpPn
         TSUW/fdk6OHy3gzaSAWCcv3TLB/VLGksjaLphC5RxaxTcoZAZvCywnxVHkbbaSrp2FWX
         dDxodQbB3x4TNXu/WVwc/MUgrGiOlLVL4c2+HkreeY5ock8/RPgmS/ZX2rg8d/bNaybT
         TTzvL7/wUTcG1xJuNmc4/NJUTjkWGreuIRUOWWscc4cU2bJ6fSykq2dLNIsB0HjNGmvW
         2oWQ==
X-Gm-Message-State: APjAAAXSlMDa02m6pZO/TlhpBHp5zWV/oIwnQ48IGcmCb1NahCi9Zkup
        Lj9Misgqv2gGAuywYEcimavKtg==
X-Google-Smtp-Source: APXvYqzLfa6mB53r67UDMjQCKejKBIn+YrmuY3wys2gdKrsrsMSEhdOHpEKYG/W3HLJzNJrxjyoBgQ==
X-Received: by 2002:a5d:5234:: with SMTP id i20mr7998319wra.403.1579651271992;
        Tue, 21 Jan 2020 16:01:11 -0800 (PST)
Received: from localhost ([2620:10d:c092:180::1:58ec])
        by smtp.gmail.com with ESMTPSA id n3sm1341159wmc.27.2020.01.21.16.01.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jan 2020 16:01:11 -0800 (PST)
Date:   Wed, 22 Jan 2020 00:01:10 +0000
From:   Chris Down <chris@chrisdown.name>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     Stanislav Fomichev <sdf@google.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        linux-kernel@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v2] bpf: btf: Always output invariant hit in pahole DWARF to
 BTF transform
Message-ID: <20200122000110.GA310073@chrisdown.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When trying to compile with CONFIG_DEBUG_INFO_BTF enabled, I got this
error:

    % make -s
    Failed to generate BTF for vmlinux
    Try to disable CONFIG_DEBUG_INFO_BTF
    make[3]: *** [vmlinux] Error 1

Compiling again without -s shows the true error (that pahole is
missing), but since this is fatal, we should show the error
unconditionally on stderr as well, not silence it using the `info`
function. With this patch:

    % make -s
    BTF: .tmp_vmlinux.btf: pahole (pahole) is not available
    Failed to generate BTF for vmlinux
    Try to disable CONFIG_DEBUG_INFO_BTF
    make[3]: *** [vmlinux] Error 1

Signed-off-by: Chris Down <chris@chrisdown.name>
Cc: Stanislav Fomichev <sdf@google.com>
Cc: Andrii Nakryiko <andriin@fb.com>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org
Cc: bpf@vger.kernel.org
Cc: kernel-team@fb.com
---
 scripts/link-vmlinux.sh | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
index c287ad9b3a67..bbe9be2bf5ff 100755
--- a/scripts/link-vmlinux.sh
+++ b/scripts/link-vmlinux.sh
@@ -108,13 +108,13 @@ gen_btf()
 	local bin_arch
 
 	if ! [ -x "$(command -v ${PAHOLE})" ]; then
-		info "BTF" "${1}: pahole (${PAHOLE}) is not available"
+		echo >&2 "BTF: ${1}: pahole (${PAHOLE}) is not available"
 		return 1
 	fi
 
 	pahole_ver=$(${PAHOLE} --version | sed -E 's/v([0-9]+)\.([0-9]+)/\1\2/')
 	if [ "${pahole_ver}" -lt "113" ]; then
-		info "BTF" "${1}: pahole version $(${PAHOLE} --version) is too old, need at least v1.13"
+		echo >&2 "BTF: ${1}: pahole version $(${PAHOLE} --version) is too old, need at least v1.13"
 		return 1
 	fi
 
-- 
2.25.0

