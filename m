Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC05F34CF61
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 13:51:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231383AbhC2Luj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 07:50:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231464AbhC2Lua (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 07:50:30 -0400
Received: from ustc.edu.cn (email6.ustc.edu.cn [IPv6:2001:da8:d800::8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id ABBE3C061574;
        Mon, 29 Mar 2021 04:50:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mail.ustc.edu.cn; s=dkim; h=Received:From:To:Cc:Subject:Date:
        Message-Id:MIME-Version:Content-Transfer-Encoding; bh=vP+XJ1pyvg
        bdFg3L0Y9Fk0jxHhZt3M1r+adOKJxCnW4=; b=iI+Uv9H9d+uCCQWblbJ9h/lP54
        Qc4700Q4+ZOPuSlLa3lMcyxX6DTjy7lMtZGv7leFnccy6Uhgjt/fnmxyMYDdStt4
        iRKo7G0mSCRzSeRkaIBQ8J3+jcOlWFGnjWBgS+m3pmLYNXGuXS89G/3Sf9CVAVp+
        ZHNZIDT67SYNa0a80=
Received: from ubuntu.localdomain (unknown [202.38.69.14])
        by newmailweb.ustc.edu.cn (Coremail) with SMTP id LkAmygBnb3_uvmFg_lBnAA--.904S4;
        Mon, 29 Mar 2021 19:50:06 +0800 (CST)
From:   Lv Yunlong <lyl2019@mail.ustc.edu.cn>
To:     kuba@kernel.org, simon.horman@netronome.com, davem@davemloft.net,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        oss-drivers@netronome.com, linux-kernel@vger.kernel.org,
        Lv Yunlong <lyl2019@mail.ustc.edu.cn>
Subject: [PATCH] ethernet/netronome/nfp: Fix a use after free in nfp_bpf_ctrl_msg_rx
Date:   Mon, 29 Mar 2021 04:50:02 -0700
Message-Id: <20210329115002.8557-1-lyl2019@mail.ustc.edu.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: LkAmygBnb3_uvmFg_lBnAA--.904S4
X-Coremail-Antispam: 1UD129KBjvdXoW7XryxKw17AF1ftrWrKF4DArb_yoWftFXEkr
        1jgFWfG3yUGw15KwsF9r4a93sYkr1qv3s5CFZxKrWSv3y5CF17XrZY9rykZa47Ww4xAa9r
        Xr9IqryUAa48tjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbfxFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
        6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
        A2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_
        Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s
        0DM2vYz4IE04k24VAvwVAKI4IrM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI
        64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8Jw
        Am72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAG
        YxC7M4IIrI8v6xkF7I0E8cxan2IY04v7MxkIecxEwVAFwVW8KwCF04k20xvY0x0EwIxGrw
        CFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE
        14v26r106r1rMI8E67AF67kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2
        IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxK
        x2IYs7xG6rWUJVWrZr1UMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxV
        AFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUS_M-UUUUU=
X-CM-SenderInfo: ho1ojiyrz6zt1loo32lwfovvfxof0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In nfp_bpf_ctrl_msg_rx, if
nfp_ccm_get_type(skb) == NFP_CCM_TYPE_BPF_BPF_EVENT is true, the skb
will be freed. But the skb is still used by nfp_ccm_rx(&bpf->ccm, skb).

My patch adds a return when the skb was freed.

Fixes: bcf0cafab44fd ("nfp: split out common control message handling code")
Signed-off-by: Lv Yunlong <lyl2019@mail.ustc.edu.cn>
---
 drivers/net/ethernet/netronome/nfp/bpf/cmsg.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/netronome/nfp/bpf/cmsg.c b/drivers/net/ethernet/netronome/nfp/bpf/cmsg.c
index 0e2db6ea79e9..2ec62c8d86e1 100644
--- a/drivers/net/ethernet/netronome/nfp/bpf/cmsg.c
+++ b/drivers/net/ethernet/netronome/nfp/bpf/cmsg.c
@@ -454,6 +454,7 @@ void nfp_bpf_ctrl_msg_rx(struct nfp_app *app, struct sk_buff *skb)
 			dev_consume_skb_any(skb);
 		else
 			dev_kfree_skb_any(skb);
+		return;
 	}
 
 	nfp_ccm_rx(&bpf->ccm, skb);
-- 
2.25.1


