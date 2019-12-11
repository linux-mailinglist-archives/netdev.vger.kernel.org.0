Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63F1211BFF5
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 23:35:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726847AbfLKWfU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 17:35:20 -0500
Received: from mail-pf1-f201.google.com ([209.85.210.201]:38977 "EHLO
        mail-pf1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727064AbfLKWee (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 17:34:34 -0500
Received: by mail-pf1-f201.google.com with SMTP id i196so38646pfe.6
        for <netdev@vger.kernel.org>; Wed, 11 Dec 2019 14:34:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=5AhdXmPKS0JiQuHlniKRJHWxS22JqYuwMDsvrT9JMfs=;
        b=lB/oei63/sAcH89+V93til6fN/6F4X/UcwDCuMEW2z20zvLpRYxp6tbM7sW3X9BZlo
         /QtDi+qmTeJzFlCzIUcXsgjp2JA+qx9E7EvVKpKIHAy+hvQQSdzV5jPGAe0Wa8bmPB3y
         7eweDWffEI1IaCtN/Fp0OtuL6QF+RNRC73BGNLZtoqCuB8LZEHimoYzhFMpIy5kqEYFC
         X5bc13g9GwWLNfQMaZG+MoifnE9u3uLUqdRDboe309tfHmdqzpkbZP8zcnbNIf9waAUo
         qxMp3jfxIub34hDAOim4pcHB1e92YhnZHAYJYSWAQcrmYrwomrFCrwX+8Axu3BN7PXEd
         fvKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=5AhdXmPKS0JiQuHlniKRJHWxS22JqYuwMDsvrT9JMfs=;
        b=cZyb5NGrHfX4VXw7X4B3KMAPT2IFK+6z2YEZFVbiGBgGgxmKKgEpimzSS5irUawWE7
         b8XXRYc3xLDHyWnF/K4k+MXTZK7wv3NJVF0f4Aa90kAPt5YsG7EObNXafWAZ0ZICzMx+
         2TabFavXXog0Tq8wu5RgOkDi0STOzjNlswYTxUzFwygARp4+SK20FmbICBd/SQjldlLP
         9/jFxfOqlJsysiBBSfpm8v7Ugh/QCPHWo7kRXWLV75Cx2/VPX2jonAIxwWsedK82fm/F
         MqKhoeY4FnimEKztuOM92FKedVyZfF45k4v8fYy+aIlmsAaIM8i1Pmh2RB+pvlTc04Bx
         /Jvw==
X-Gm-Message-State: APjAAAUonqtQX6an4qvvJHp73BTUSJQM/Cw4yfQPmVzS9gLFkS3l0WHA
        wDjaTxTcWWZyEbnj92/PsbJOhocgIGE9
X-Google-Smtp-Source: APXvYqzvLtomxTN9fAdNSflYuVsHsM/b3e23KaWeDADeXX0GG4+Yzq5XdJNQgJpdumTdY/7TVwHiMmaC4rnx
X-Received: by 2002:a65:4c06:: with SMTP id u6mr7000062pgq.412.1576103673604;
 Wed, 11 Dec 2019 14:34:33 -0800 (PST)
Date:   Wed, 11 Dec 2019 14:33:38 -0800
In-Reply-To: <20191211223344.165549-1-brianvv@google.com>
Message-Id: <20191211223344.165549-6-brianvv@google.com>
Mime-Version: 1.0
References: <20191211223344.165549-1-brianvv@google.com>
X-Mailer: git-send-email 2.24.1.735.g03f4e72817-goog
Subject: [PATCH v3 bpf-next 05/11] bpf: add generic_batch_ops to lpm_trie map
From:   Brian Vazquez <brianvv@google.com>
To:     Brian Vazquez <brianvv.kernel@gmail.com>,
        Brian Vazquez <brianvv@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Yonghong Song <yhs@fb.com>, Stanislav Fomichev <sdf@google.com>,
        Petar Penkov <ppenkov@google.com>,
        Willem de Bruijn <willemb@google.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds the generic batch ops functionality to bpf lpm_trie.

Signed-off-by: Brian Vazquez <brianvv@google.com>
---
 kernel/bpf/lpm_trie.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/bpf/lpm_trie.c b/kernel/bpf/lpm_trie.c
index 56e6c75d354d9..92c47b4f03337 100644
--- a/kernel/bpf/lpm_trie.c
+++ b/kernel/bpf/lpm_trie.c
@@ -743,4 +743,8 @@ const struct bpf_map_ops trie_map_ops = {
 	.map_update_elem = trie_update_elem,
 	.map_delete_elem = trie_delete_elem,
 	.map_check_btf = trie_check_btf,
+	.map_lookup_batch = generic_map_lookup_batch,
+	.map_lookup_and_delete_batch = generic_map_lookup_and_delete_batch,
+	.map_delete_batch = generic_map_delete_batch,
+	.map_update_batch = generic_map_update_batch,
 };
-- 
2.24.1.735.g03f4e72817-goog

