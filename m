Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DC2A1CC129
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 14:07:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728537AbgEIMHu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 08:07:50 -0400
Received: from mout.kundenserver.de ([217.72.192.74]:45837 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727093AbgEIMHq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 08:07:46 -0400
Received: from localhost.localdomain ([149.172.19.189]) by
 mrelayeu.kundenserver.de (mreue107 [212.227.15.145]) with ESMTPA (Nemesis) id
 1MHWvH-1jKU520UVt-00DX52; Sat, 09 May 2020 14:07:13 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Michal Kazior <michal.kazior@tieto.com>,
        Kalle Valo <kvalo@qca.qualcomm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Wen Gong <wgong@codeaurora.org>,
        Erik Stromdahl <erik.stromdahl@gmail.com>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/2] ath10k: fix gcc-10 zero-length-bounds warnings
Date:   Sat,  9 May 2020 14:06:32 +0200
Message-Id: <20200509120707.188595-1-arnd@arndb.de>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:md3rGtm9B4AL9nvSbhTd+KISJpmcfvjMjuz727nzZm2ZvFT08RI
 4X3GNiglYQmcZcXlGiFzAfI8qklVyu72RVyCSXUtfldCvePSj61BDEZlHHReaflvqiznmoE
 5HonKZMPDVDwN29blRt/Ip7sw3mul8n1tgqN9WkhOKVzXFNcOZT5DWfk95qwreYQPZT6ryz
 eD7aa3o1noCIrZFf+tmXg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:xnYyufblF38=:aqdJovHTUmVD7l7sJtYi6R
 O2VyTtN8cEC5i1EHJ/QrGJTzuZeDvWHv+4wBXmOdq+vCri1/O+O8ZHnHEU62SyfrF2VyfbL40
 3urDiERgiSr77LhdpxdMwRpoS8l2vfp6FvbIf2nz4ag/rn55duaDINqQSGCsJlTA/CNQQP0jA
 l6hqytr7uwp+aJzEUwGvkOHrv83UTBoC/MSyc2w1eqkEFKPb0CpMoAFJgw60vU4nYI5YDse8p
 TENge1jYBX1cKNmDact8vq15wBMtannapu9oLNfH4+OmRHVMRyiN/hUDOEQJCQgqT0aeotHkO
 Csd33s0vb2GCnFTQRRfhulmPZikLXUglgEOJkvKdwVMgOXkbWnbjFTRbh98jb8XCzrHqAEo5c
 RtjW1gozK+Ex0mMRGBCPUX5OcpV/WjDP4LdlMpbDPHYPfw2zA0slct/rVbfh3q6Y2U45h7OFp
 T8+JCeAntbaV/B3DRDFUeW7EoheAdm4WGc+FOn1xP9r8QxDXlelhmOTDqJ6BqjIXxYl7NgZ/w
 2KPZp/Ra90JLJeLJrbK4XkYJNA3JE/YPLKLOVSlaTPT8tnn5FSOVKoQ92RVzs1qTjfk5kGREu
 J05vfQLaHM3KrUEV79aUqy6k1iOi8ZPVrYEnyGH5EKHeNEkF0SfODkaDa6HhzDqKgQO/MN8d1
 9S0A+9/C/kF+KJhNTCmScZYK6WS4xkZa9tKHHZ3MCSOXS9+FGw7oIgvrs4U+IufVz3qsAGECG
 JQiilaFIEJbIHBCoYPfe2Bq2WjwoZr+Uw83CMMw0aUvIJdeHeqv9MMZC07pzZyXotRlPTRJbz
 FEJswylkJbsUwPMFx0fF8aI6b2RjADap9Uy5S4eazZvyxlM9dE=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

gcc-10 started warning about out-of-bounds access for zero-length
arrays:

In file included from drivers/net/wireless/ath/ath10k/core.h:18,
                 from drivers/net/wireless/ath/ath10k/htt_rx.c:8:
drivers/net/wireless/ath/ath10k/htt_rx.c: In function 'ath10k_htt_rx_tx_fetch_ind':
drivers/net/wireless/ath/ath10k/htt.h:1683:17: warning: array subscript 65535 is outside the bounds of an interior zero-length array 'struct htt_tx_fetch_record[0]' [-Wzero-length-bounds]
 1683 |  return (void *)&ind->records[le16_to_cpu(ind->num_records)];
      |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/net/wireless/ath/ath10k/htt.h:1676:29: note: while referencing 'records'
 1676 |  struct htt_tx_fetch_record records[0];
      |                             ^~~~~~~

Make records[] a flexible array member to allow this, moving it behind
the other zero-length member that is not accessed in a way that gcc
warns about.

Fixes: 3ba225b506a2 ("treewide: Replace zero-length array with flexible-array member")
Fixes: 22e6b3bc5d96 ("ath10k: add new htt definitions")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/wireless/ath/ath10k/htt.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt.h b/drivers/net/wireless/ath/ath10k/htt.h
index 8f3710cf28f4..aa056a186402 100644
--- a/drivers/net/wireless/ath/ath10k/htt.h
+++ b/drivers/net/wireless/ath/ath10k/htt.h
@@ -1673,8 +1673,8 @@ struct htt_tx_fetch_ind {
 	__le32 token;
 	__le16 num_resp_ids;
 	__le16 num_records;
-	struct htt_tx_fetch_record records[0];
 	__le32 resp_ids[0]; /* ath10k_htt_get_tx_fetch_ind_resp_ids() */
+	struct htt_tx_fetch_record records[];
 } __packed;
 
 static inline void *
-- 
2.26.0

