Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D341D10A37A
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 18:42:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728095AbfKZRmZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 12:42:25 -0500
Received: from mail-pl1-f202.google.com ([209.85.214.202]:46785 "EHLO
        mail-pl1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727126AbfKZRmZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 12:42:25 -0500
Received: by mail-pl1-f202.google.com with SMTP id q19so1114628pll.13
        for <netdev@vger.kernel.org>; Tue, 26 Nov 2019 09:42:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=koHXHkycCC0RdtCRZro1StIOslXq5D+D62eiHw9Flhk=;
        b=M9osQM3xupebKiarCbBfaEBDCeRxLqS0ovX0pUR3Sa9DQ+2nYS8TRN0vYb74sAX4X8
         nEFBfEen0wg4+sPtWZ16NcSMYgq6Ne6v2GwCVfw9ogIox2HpGK4uHw+w4LLPpMUrMLHN
         OVOoVOPLgSdwIhpsHOU4OxoxSq3OmnUs0kPZp+1IEYYgeE8kQadAwrdkFL+N1iNB/buy
         jSZUkTWMW6EJh+/5kWP+55yxCczt1TSvJU0W6Myehc9aAGABL/uJ8ZwZa+Ev44UCLR6h
         nnQzoHSEj3eyFwZA+h9RAaD//8N1X1a81eLQEwkYq4kV3AlW1G3HzSNrL+yzlRgJXXh4
         RXYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=koHXHkycCC0RdtCRZro1StIOslXq5D+D62eiHw9Flhk=;
        b=J2DiqN9cMU+xLDIdEWlXEutZVi0t8GISFWXjWWUccgk0Ei9TOXykdsNDIrHT3PJfoE
         s11DkrmfSOHcxwE17+7jBV968eKQ/FyVLa42BSK07mZI6tjrXu4/XyPMhiuHQt6Kqx0J
         URZ0+RSbSGe2d+Hto23ldT71DikEqvNuT/dcWaWTjVh3Eh4KFE9mn5oJpeTY5g0r04Kq
         KZkA1lnqmigozvMsa7/QhXmcAqEMqoYV+f9QJOtLxUgB7m0rYq+6gLJQoFMns/FnC40Z
         IlcPWPz9afxEmKbmGAHRZLLXd9YufvDKP/shhBacCznsbu3jBtDdXsJN6PK+Daq44U9k
         X74g==
X-Gm-Message-State: APjAAAV8iNMZjV1f1aKgnA4C9u1XU+x6cZDQ+zK77Qeyb6x4Tfrtv1mW
        9ZCU6iwJr03JjaQbG5ECqUBA8zGtS/dHB2t+jyVVF6/HNQx2W/VDUS21BuvIvNvKUDdSe/p0lZK
        kzJ2yn1QhwVSMwxAc/cQ28BogQKyVtyMf2dRLuaaPMTFAdzPwZVwvNw==
X-Google-Smtp-Source: APXvYqxUNd/vab7H1MJ9YeZ6yNLacHCJmUTYhxrtASbw9nQ2yktSp6GU9aeQiPpp/2yQClDJbgbnd9s=
X-Received: by 2002:a63:1d0a:: with SMTP id d10mr40133518pgd.242.1574790144653;
 Tue, 26 Nov 2019 09:42:24 -0800 (PST)
Date:   Tue, 26 Nov 2019 09:42:21 -0800
Message-Id: <20191126174221.200522-1-sdf@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.0.432.g9d3f5f5b63-goog
Subject: [PATCH bpf] bpf: support pre-2.25-binutils objcopy for vmlinux BTF
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If vmlinux BTF generation fails, but CONFIG_DEBUG_INFO_BTF is set,
.BTF section of vmlinux is empty and kernel will prohibit
BPF loading and return "in-kernel BTF is malformed".

--dump-section argument to binutils' objcopy was added in version 2.25.
When using pre-2.25 binutils, BTF generation silently fails. Convert
to --only-section which is present on pre-2.25 binutils.

Documentation/process/changes.rst states that binutils 2.21+
is supported, not sure those standards apply to BPF subsystem.

Fixes: 341dfcf8d78ea ("btf: expose BTF info through sysfs")
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 scripts/link-vmlinux.sh | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
index 06495379fcd8..c56ba91f52b0 100755
--- a/scripts/link-vmlinux.sh
+++ b/scripts/link-vmlinux.sh
@@ -127,7 +127,8 @@ gen_btf()
 		cut -d, -f1 | cut -d' ' -f2)
 	bin_format=$(LANG=C ${OBJDUMP} -f ${1} | grep 'file format' | \
 		awk '{print $4}')
-	${OBJCOPY} --dump-section .BTF=.btf.vmlinux.bin ${1} 2>/dev/null
+	${OBJCOPY} --set-section-flags .BTF=alloc -O binary \
+		--only-section=.BTF ${1} .btf.vmlinux.bin 2>/dev/null
 	${OBJCOPY} -I binary -O ${bin_format} -B ${bin_arch} \
 		--rename-section .data=.BTF .btf.vmlinux.bin ${2}
 }
-- 
2.24.0.432.g9d3f5f5b63-goog

