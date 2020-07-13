Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 468F121CE72
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 06:54:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726491AbgGMEyM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 00:54:12 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:55078 "EHLO
        www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725804AbgGMEyL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 00:54:11 -0400
Received: from fsav403.sakura.ne.jp (fsav403.sakura.ne.jp [133.242.250.102])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 06D4rcrT033467;
        Mon, 13 Jul 2020 13:53:38 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav403.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav403.sakura.ne.jp);
 Mon, 13 Jul 2020 13:53:38 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav403.sakura.ne.jp)
Received: from localhost.localdomain (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 06D4rXGD033370
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Mon, 13 Jul 2020 13:53:38 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
From:   Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        kbuild test robot <lkp@intel.com>
Subject: [PATCH] net: fddi: skfp: Remove addr_to_string().
Date:   Mon, 13 Jul 2020 13:53:30 +0900
Message-Id: <20200713045330.3721-1-penguin-kernel@I-love.SAKURA.ne.jp>
X-Mailer: git-send-email 2.18.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

kbuild test robot found that addr_to_string() is available only when
DEBUG is defined. And I found that what that function is doing is
what %pM will do. Thus, replace %s with %pM and remove thread-unsafe
addr_to_string() function.

Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 drivers/net/fddi/skfp/ess.c      | 10 +++---
 drivers/net/fddi/skfp/h/cmtdef.h |  1 -
 drivers/net/fddi/skfp/smt.c      | 60 ++++++++++++--------------------
 3 files changed, 27 insertions(+), 44 deletions(-)

diff --git a/drivers/net/fddi/skfp/ess.c b/drivers/net/fddi/skfp/ess.c
index a546eaf071f7..afd5ca39f43b 100644
--- a/drivers/net/fddi/skfp/ess.c
+++ b/drivers/net/fddi/skfp/ess.c
@@ -148,7 +148,7 @@ int ess_raf_received_pack(struct s_smc *smc, SMbuf *mb, struct smt_header *sm,
 
 	DB_ESSN(2, "fc %x	ft %x", sm->smt_class, sm->smt_type);
 	DB_ESSN(2, "ver %x	tran %x", sm->smt_version, sm->smt_tid);
-	DB_ESSN(2, "stn_id %s", addr_to_string(&sm->smt_source));
+	DB_ESSN(2, "stn_id %pM", &sm->smt_source);
 
 	DB_ESSN(2, "infolen %x	res %lx", sm->smt_len, msg_res_type);
 	DB_ESSN(2, "sbacmd %x", cmd->sba_cmd);
@@ -308,8 +308,8 @@ int ess_raf_received_pack(struct s_smc *smc, SMbuf *mb, struct smt_header *sm,
 		p = (void *) sm_to_para(smc,sm,SMT_P3210) ;
 		overhead = ((struct smt_p_3210 *)p)->mib_overhead ;
 
-		DB_ESSN(2, "ESS: Change Request from %s",
-			addr_to_string(&sm->smt_source));
+		DB_ESSN(2, "ESS: Change Request from %pM",
+			&sm->smt_source);
 		DB_ESSN(2, "payload= %lx	overhead= %lx",
 			payload, overhead);
 
@@ -339,8 +339,8 @@ int ess_raf_received_pack(struct s_smc *smc, SMbuf *mb, struct smt_header *sm,
 			return fs;
 		}
 
-		DB_ESSN(2, "ESS: Report Request from %s",
-			addr_to_string(&sm->smt_source));
+		DB_ESSN(2, "ESS: Report Request from %pM",
+			&sm->smt_source);
 
 		/*
 		 * verify that the resource type is sync bw only
diff --git a/drivers/net/fddi/skfp/h/cmtdef.h b/drivers/net/fddi/skfp/h/cmtdef.h
index 3a1ceb7cb8d2..4dd590d65d76 100644
--- a/drivers/net/fddi/skfp/h/cmtdef.h
+++ b/drivers/net/fddi/skfp/h/cmtdef.h
@@ -640,7 +640,6 @@ void dump_smt(struct s_smc *smc, struct smt_header *sm, char *text);
 #define	dump_smt(smc,sm,text)
 #endif
 
-char* addr_to_string(struct fddi_addr *addr);
 #ifdef	DEBUG
 void dump_hex(char *p, int len);
 #endif
diff --git a/drivers/net/fddi/skfp/smt.c b/drivers/net/fddi/skfp/smt.c
index 47c48202a68c..b8c59d803ce6 100644
--- a/drivers/net/fddi/skfp/smt.c
+++ b/drivers/net/fddi/skfp/smt.c
@@ -520,8 +520,8 @@ void smt_received_pack(struct s_smc *smc, SMbuf *mb, int fs)
 	 * ignore any packet with NSA and A-indicator set
 	 */
 	if ( (fs & A_INDICATOR) && m_fc(mb) == FC_SMT_NSA) {
-		DB_SMT("SMT : ignoring NSA with A-indicator set from %s",
-		       addr_to_string(&sm->smt_source));
+		DB_SMT("SMT : ignoring NSA with A-indicator set from %pM",
+		       &sm->smt_source);
 		smt_free_mbuf(smc,mb) ;
 		return ;
 	}
@@ -552,8 +552,8 @@ void smt_received_pack(struct s_smc *smc, SMbuf *mb, int fs)
 		break ;
 	}
 	if (illegal) {
-		DB_SMT("SMT : version = %d, dest = %s",
-		       sm->smt_version, addr_to_string(&sm->smt_source));
+		DB_SMT("SMT : version = %d, dest = %pM",
+		       sm->smt_version, &sm->smt_source);
 		smt_send_rdf(smc,mb,m_fc(mb),SMT_RDF_VERSION,local) ;
 		smt_free_mbuf(smc,mb) ;
 		return ;
@@ -582,8 +582,8 @@ void smt_received_pack(struct s_smc *smc, SMbuf *mb, int fs)
 				if (!is_equal(
 					&smc->mib.m[MAC0].fddiMACUpstreamNbr,
 					&sm->smt_source)) {
-					DB_SMT("SMT : updated my UNA = %s",
-					       addr_to_string(&sm->smt_source));
+					DB_SMT("SMT : updated my UNA = %pM",
+					       &sm->smt_source);
 					if (!is_equal(&smc->mib.m[MAC0].
 					    fddiMACUpstreamNbr,&SMT_Unknown)){
 					 /* Do not update unknown address */
@@ -612,8 +612,8 @@ void smt_received_pack(struct s_smc *smc, SMbuf *mb, int fs)
 			    is_individual(&sm->smt_source) &&
 			    ((!(fs & A_INDICATOR) && m_fc(mb) == FC_SMT_NSA) ||
 			     (m_fc(mb) != FC_SMT_NSA))) {
-				DB_SMT("SMT : replying to NIF request %s",
-				       addr_to_string(&sm->smt_source));
+				DB_SMT("SMT : replying to NIF request %pM",
+				       &sm->smt_source);
 				smt_send_nif(smc,&sm->smt_source,
 					FC_SMT_INFO,
 					sm->smt_tid,
@@ -621,8 +621,8 @@ void smt_received_pack(struct s_smc *smc, SMbuf *mb, int fs)
 			}
 			break ;
 		case SMT_REPLY :
-			DB_SMT("SMT : received NIF response from %s",
-			       addr_to_string(&sm->smt_source));
+			DB_SMT("SMT : received NIF response from %pM",
+			       &sm->smt_source);
 			if (fs & A_INDICATOR) {
 				smc->sm.pend[SMT_TID_NIF] = 0 ;
 				DB_SMT("SMT : duplicate address");
@@ -682,23 +682,23 @@ void smt_received_pack(struct s_smc *smc, SMbuf *mb, int fs)
 	case SMT_SIF_CONFIG :	/* station information */
 		if (sm->smt_type != SMT_REQUEST)
 			break ;
-		DB_SMT("SMT : replying to SIF Config request from %s",
-		       addr_to_string(&sm->smt_source));
+		DB_SMT("SMT : replying to SIF Config request from %pM",
+		       &sm->smt_source);
 		smt_send_sif_config(smc,&sm->smt_source,sm->smt_tid,local) ;
 		break ;
 	case SMT_SIF_OPER :	/* station information */
 		if (sm->smt_type != SMT_REQUEST)
 			break ;
-		DB_SMT("SMT : replying to SIF Operation request from %s",
-		       addr_to_string(&sm->smt_source));
+		DB_SMT("SMT : replying to SIF Operation request from %pM",
+		       &sm->smt_source);
 		smt_send_sif_operation(smc,&sm->smt_source,sm->smt_tid,local) ;
 		break ;
 	case SMT_ECF :		/* echo frame */
 		switch (sm->smt_type) {
 		case SMT_REPLY :
 			smc->mib.priv.fddiPRIVECF_Reply_Rx++ ;
-			DB_SMT("SMT: received ECF reply from %s",
-			       addr_to_string(&sm->smt_source));
+			DB_SMT("SMT: received ECF reply from %pM",
+			       &sm->smt_source);
 			if (sm_to_para(smc,sm,SMT_P_ECHODATA) == NULL) {
 				DB_SMT("SMT: ECHODATA missing");
 				break ;
@@ -727,8 +727,8 @@ void smt_received_pack(struct s_smc *smc, SMbuf *mb, int fs)
 					local) ;
 				break ;
 			}
-			DB_SMT("SMT - sending ECF reply to %s",
-			       addr_to_string(&sm->smt_source));
+			DB_SMT("SMT - sending ECF reply to %pM",
+			       &sm->smt_source);
 
 			/* set destination addr.  & reply */
 			sm->smt_dest = sm->smt_source ;
@@ -794,8 +794,8 @@ void smt_received_pack(struct s_smc *smc, SMbuf *mb, int fs)
 		 * we need to send a RDF frame according to 8.1.3.1.1,
 		 * only if it is a REQUEST.
 		 */
-		DB_SMT("SMT : class = %d, send RDF to %s",
-		       sm->smt_class, addr_to_string(&sm->smt_source));
+		DB_SMT("SMT : class = %d, send RDF to %pM",
+		       sm->smt_class, &sm->smt_source);
 
 		smt_send_rdf(smc,mb,m_fc(mb),SMT_RDF_CLASS,local) ;
 		break ;
@@ -864,8 +864,8 @@ static void smt_send_rdf(struct s_smc *smc, SMbuf *rej, int fc, int reason,
 	if (sm->smt_type != SMT_REQUEST)
 		return ;
 
-	DB_SMT("SMT: sending RDF to %s,reason = 0x%x",
-	       addr_to_string(&sm->smt_source), reason);
+	DB_SMT("SMT: sending RDF to %pM,reason = 0x%x",
+	       &sm->smt_source, reason);
 
 
 	/*
@@ -1715,22 +1715,6 @@ void fddi_send_antc(struct s_smc *smc, struct fddi_addr *dest)
 }
 #endif
 
-#ifdef	DEBUG
-char *addr_to_string(struct fddi_addr *addr)
-{
-	int	i ;
-	static char	string[6*3] = "****" ;
-
-	for (i = 0 ; i < 6 ; i++) {
-		string[i * 3] = hex_asc_hi(addr->a[i]);
-		string[i * 3 + 1] = hex_asc_lo(addr->a[i]);
-		string[i * 3 + 2] = ':';
-	}
-	string[5 * 3 + 2] = 0;
-	return string;
-}
-#endif
-
 /*
  * return static mac index
  */
-- 
2.18.4

