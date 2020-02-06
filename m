Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26B971541E1
	for <lists+netdev@lfdr.de>; Thu,  6 Feb 2020 11:29:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728479AbgBFK3d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Feb 2020 05:29:33 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:56995 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728304AbgBFK3d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Feb 2020 05:29:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580984972;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=rLvLgIFZDxpilM3hf5DEhzcY/HFRNtYD6YOwnh0ogoY=;
        b=h5o1eGldVWADIgwt4ahfL8uohvV237L2TACJFkw3g7H7Ou87/dKmhQP+evFzCHsVQTa5MI
        /bkM4ISR/EH/wEJ940o9SEANvpsk7SlLfw2r5AoPql++UeyIX8KvSly6wqJT2Ecxi1DkcX
        Wq14liJ+3EraTwXChLJjygHJajPI+b4=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-290-0HHth0kENb6V9ATQzHXoKA-1; Thu, 06 Feb 2020 05:29:29 -0500
X-MC-Unique: 0HHth0kENb6V9ATQzHXoKA-1
Received: by mail-lj1-f197.google.com with SMTP id y24so877504ljc.19
        for <netdev@vger.kernel.org>; Thu, 06 Feb 2020 02:29:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rLvLgIFZDxpilM3hf5DEhzcY/HFRNtYD6YOwnh0ogoY=;
        b=g4uUJBxeUA4sDne1HEpKWDYkwuBY9dgyXi6Tr/1fwjCHeoR2qyvA4wZgyPiPnDpewW
         Non6EkvHR3z9gCdRgbqRgXS3SHqWAhXcJeJ6M/teXau8SU6en7gBvW5LR3fw/nXCU8bB
         6Clizce4aVl554+PYZ04r0AUAc/AxW7hT0+FmN9hlytcMCjIyck+GBQM6y9sIuQWPzSz
         KBOlt4ONjr6F65glgeha2sxoD2U41UJiQpk/WqUn+Oteb9SITJVTsF3kjFyY1LziuFio
         1diy7hRAnuq6XEMmC/rMGdBB1mBr2TD53lHYKp725oO2+zKF4DFtp3clH0hTxQLy0Bsj
         DP3A==
X-Gm-Message-State: APjAAAXSQFXx4tEFpTF5c5bHHz3/Y0h1ypsMlNY+phINoBF7lqP7f2ae
        Xaz2Hb9aEYLXRlqX4PvrY8bf4vEfv66KOAdEsuYXnu1urT8pSYyKc1nfvG7CvCU3uNORMEsgKEP
        RPAl+AH9n9hCV88yq
X-Received: by 2002:ac2:5335:: with SMTP id f21mr1447277lfh.150.1580984968426;
        Thu, 06 Feb 2020 02:29:28 -0800 (PST)
X-Google-Smtp-Source: APXvYqxwYbfo9IHDqEGxf6Vub/TsJPik3bcwC8zpaV6QIIn8M6U1RKrDRN0ymXE20jLuePMN6xC3CA==
X-Received: by 2002:ac2:5335:: with SMTP id f21mr1447259lfh.150.1580984968139;
        Thu, 06 Feb 2020 02:29:28 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id y21sm1050515lfy.46.2020.02.06.02.29.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Feb 2020 02:29:27 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 31CC71802D4; Thu,  6 Feb 2020 11:29:24 +0100 (CET)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     daniel@iogearbox.net, ast@fb.com
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        bpf@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH bpf] bpftool: Don't crash on missing xlated program instructions
Date:   Thu,  6 Feb 2020 11:29:06 +0100
Message-Id: <20200206102906.112551-1-toke@redhat.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Turns out the xlated program instructions can also be missing if
kptr_restrict sysctl is set. This means that the previous fix to check the
jited_prog_insns pointer was insufficient; add another check of the
xlated_prog_insns pointer as well.

Fixes: 5b79bcdf0362 ("bpftool: Don't crash on missing jited insns or ksyms")
Fixes: cae73f233923 ("bpftool: use bpf_program__get_prog_info_linear() in prog.c:do_dump()")
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 tools/bpf/bpftool/prog.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
index a3521deca869..b352ab041160 100644
--- a/tools/bpf/bpftool/prog.c
+++ b/tools/bpf/bpftool/prog.c
@@ -536,7 +536,7 @@ prog_dump(struct bpf_prog_info *info, enum dump_mode mode,
 		buf = (unsigned char *)(info->jited_prog_insns);
 		member_len = info->jited_prog_len;
 	} else {	/* DUMP_XLATED */
-		if (info->xlated_prog_len == 0) {
+		if (info->xlated_prog_len == 0 || !info->xlated_prog_insns) {
 			p_err("error retrieving insn dump: kernel.kptr_restrict set?");
 			return -1;
 		}
-- 
2.25.0

