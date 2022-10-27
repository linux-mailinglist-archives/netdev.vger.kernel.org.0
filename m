Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84920610297
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 22:21:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236942AbiJ0UU5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 16:20:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236941AbiJ0UUz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 16:20:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 739B562A7A;
        Thu, 27 Oct 2022 13:20:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0C088B827BE;
        Thu, 27 Oct 2022 20:20:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8382AC433C1;
        Thu, 27 Oct 2022 20:20:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666902050;
        bh=671QyGcvQszCHTTsJtgddvWic+PE1QNEPAqRp9OP9cg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bcx+06HkpHuPRBnQ4e93HYHRSojoT6lSy5TMxMB8uf6ORcT5AmD5pxeMSZoU3bYZw
         QxnEueJPZiMKsfkzEsPT9GjlzARLwgtTOiOo6qJ1f+xtJjE5KRLFxua82FI13S6j+/
         zdoxS1gQzAl5GjhkvGYfXuuzQW3V2a4eshrlrvGTcs6j9A6R3Qu+cnQdKS1j0R21m2
         WQVcM6tvLG2fX16EHADHfPookJzxCd+sbmNuZHpvklDdaqyyFt2eCBWSeby8hDLLQ8
         pJMXVdVoLXlSRl0j6+Vo68SArJgAFyMwm2xES5ZvuMznbqCqThZsRfvwY9tar6DLHn
         qg7XZhzlALm1g==
Date:   Thu, 27 Oct 2022 15:20:47 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Sudarsana Kalluru <skalluru@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com, Rasesh Mody <rmody@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kees Cook <keescook@chromium.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH v2 5/6] bna: Avoid clashing function prototypes
Message-ID: <2812afc0de278b97413a142d39d939a08ac74025.1666894751.git.gustavoars@kernel.org>
References: <cover.1666894751.git.gustavoars@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1666894751.git.gustavoars@kernel.org>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When built with Control Flow Integrity, function prototypes between
caller and function declaration must match. These mismatches are visible
at compile time with the new -Wcast-function-type-strict in Clang[1].

Fix a total of 227 warnings like these:

drivers/net/ethernet/brocade/bna/bna_enet.c:519:3: warning: cast from 'void (*)(struct bna_ethport *, enum bna_ethport_event)' to 'bfa_fsm_t' (aka 'void (*)(void *, int)') converts to incompatible function type [-Wcast-function-type-strict]
                bfa_fsm_set_state(ethport, bna_ethport_sm_down);
                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The bna state machine code heavily overloads its state machine functions,
so these have been separated into their own sets of structs, enums,
typedefs, and helper functions. There are almost zero binary code changes,
all seem to be related to header file line numbers changing, or the
addition of the new stats helper.

[1] https://reviews.llvm.org/D134831
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
Changes in v2:
 - None. This patch is new in the series.

 drivers/net/ethernet/brocade/bna/bfa_cs.h    | 60 +++++++++++++-------
 drivers/net/ethernet/brocade/bna/bfa_ioc.c   | 10 ++--
 drivers/net/ethernet/brocade/bna/bfa_ioc.h   |  8 ++-
 drivers/net/ethernet/brocade/bna/bfa_msgq.h  |  8 ++-
 drivers/net/ethernet/brocade/bna/bna_enet.c  |  6 +-
 drivers/net/ethernet/brocade/bna/bna_tx_rx.c |  6 +-
 drivers/net/ethernet/brocade/bna/bna_types.h | 27 +++++++--
 7 files changed, 82 insertions(+), 43 deletions(-)

diff --git a/drivers/net/ethernet/brocade/bna/bfa_cs.h b/drivers/net/ethernet/brocade/bna/bfa_cs.h
index 8f0ac7b99973..858c92129451 100644
--- a/drivers/net/ethernet/brocade/bna/bfa_cs.h
+++ b/drivers/net/ethernet/brocade/bna/bfa_cs.h
@@ -18,15 +18,43 @@
 
 /* BFA state machine interfaces */
 
-typedef void (*bfa_sm_t)(void *sm, int event);
-
 /* For converting from state machine function to state encoding. */
-struct bfa_sm_table {
-	bfa_sm_t	sm;	/*!< state machine function	*/
-	int		state;	/*!< state machine encoding	*/
-	char		*name;	/*!< state name for display	*/
-};
-#define BFA_SM(_sm)		((bfa_sm_t)(_sm))
+#define BFA_SM_TABLE(n, s, e, t)				\
+struct s;							\
+enum e;								\
+typedef void (*t)(struct s *, enum e);				\
+								\
+struct n ## _sm_table_s {					\
+	t		sm;	/* state machine function */	\
+	int		state;	/* state machine encoding */	\
+	char		*name;	/* state name for display */	\
+};								\
+								\
+static inline int						\
+n ## _sm_to_state(struct n ## _sm_table_s *smt, t sm)		\
+{								\
+	int	i = 0;						\
+								\
+	while (smt[i].sm && smt[i].sm != sm)			\
+		i++;						\
+	return smt[i].state;					\
+}
+
+BFA_SM_TABLE(iocpf,	bfa_iocpf,	iocpf_event,	bfa_fsm_iocpf_t)
+BFA_SM_TABLE(ioc,	bfa_ioc,	ioc_event,	bfa_fsm_ioc_t)
+BFA_SM_TABLE(cmdq,	bfa_msgq_cmdq,	cmdq_event,	bfa_fsm_msgq_cmdq_t)
+BFA_SM_TABLE(rspq,	bfa_msgq_rspq,	rspq_event,	bfa_fsm_msgq_rspq_t)
+
+BFA_SM_TABLE(ioceth,	bna_ioceth,	bna_ioceth_event, bna_fsm_ioceth_t)
+BFA_SM_TABLE(enet,	bna_enet,	bna_enet_event, bna_fsm_enet_t)
+BFA_SM_TABLE(ethport,	bna_ethport,	bna_ethport_event, bna_fsm_ethport_t)
+BFA_SM_TABLE(tx,	bna_tx,		bna_tx_event,	bna_fsm_tx_t)
+BFA_SM_TABLE(rxf,	bna_rxf,	bna_rxf_event, bna_fsm_rxf_t)
+BFA_SM_TABLE(rx,	bna_rx,		bna_rx_event,	bna_fsm_rx_t)
+
+#undef BFA_SM_TABLE
+
+#define BFA_SM(_sm)	(_sm)
 
 /* State machine with entry actions. */
 typedef void (*bfa_fsm_t)(void *fsm, int event);
@@ -41,24 +69,12 @@ typedef void (*bfa_fsm_t)(void *fsm, int event);
 	static void oc ## _sm_ ## st ## _entry(otype * fsm)
 
 #define bfa_fsm_set_state(_fsm, _state) do {				\
-	(_fsm)->fsm = (bfa_fsm_t)(_state);				\
+	(_fsm)->fsm = (_state);						\
 	_state ## _entry(_fsm);						\
 } while (0)
 
 #define bfa_fsm_send_event(_fsm, _event)	((_fsm)->fsm((_fsm), (_event)))
-#define bfa_fsm_cmp_state(_fsm, _state)					\
-	((_fsm)->fsm == (bfa_fsm_t)(_state))
-
-static inline int
-bfa_sm_to_state(const struct bfa_sm_table *smt, bfa_sm_t sm)
-{
-	int	i = 0;
-
-	while (smt[i].sm && smt[i].sm != sm)
-		i++;
-	return smt[i].state;
-}
-
+#define bfa_fsm_cmp_state(_fsm, _state)		((_fsm)->fsm == (_state))
 /* Generic wait counter. */
 
 typedef void (*bfa_wc_resume_t) (void *cbarg);
diff --git a/drivers/net/ethernet/brocade/bna/bfa_ioc.c b/drivers/net/ethernet/brocade/bna/bfa_ioc.c
index cd933817a0b8..b07522ac3e74 100644
--- a/drivers/net/ethernet/brocade/bna/bfa_ioc.c
+++ b/drivers/net/ethernet/brocade/bna/bfa_ioc.c
@@ -114,7 +114,7 @@ bfa_fsm_state_decl(bfa_ioc, disabling, struct bfa_ioc, enum ioc_event);
 bfa_fsm_state_decl(bfa_ioc, disabled, struct bfa_ioc, enum ioc_event);
 bfa_fsm_state_decl(bfa_ioc, hwfail, struct bfa_ioc, enum ioc_event);
 
-static struct bfa_sm_table ioc_sm_table[] = {
+static struct ioc_sm_table_s ioc_sm_table[] = {
 	{BFA_SM(bfa_ioc_sm_uninit), BFA_IOC_UNINIT},
 	{BFA_SM(bfa_ioc_sm_reset), BFA_IOC_RESET},
 	{BFA_SM(bfa_ioc_sm_enabling), BFA_IOC_ENABLING},
@@ -183,7 +183,7 @@ bfa_fsm_state_decl(bfa_iocpf, disabling_sync, struct bfa_iocpf,
 						enum iocpf_event);
 bfa_fsm_state_decl(bfa_iocpf, disabled, struct bfa_iocpf, enum iocpf_event);
 
-static struct bfa_sm_table iocpf_sm_table[] = {
+static struct iocpf_sm_table_s iocpf_sm_table[] = {
 	{BFA_SM(bfa_iocpf_sm_reset), BFA_IOCPF_RESET},
 	{BFA_SM(bfa_iocpf_sm_fwcheck), BFA_IOCPF_FWMISMATCH},
 	{BFA_SM(bfa_iocpf_sm_mismatch), BFA_IOCPF_FWMISMATCH},
@@ -2860,12 +2860,12 @@ static enum bfa_ioc_state
 bfa_ioc_get_state(struct bfa_ioc *ioc)
 {
 	enum bfa_iocpf_state iocpf_st;
-	enum bfa_ioc_state ioc_st = bfa_sm_to_state(ioc_sm_table, ioc->fsm);
+	enum bfa_ioc_state ioc_st = ioc_sm_to_state(ioc_sm_table, ioc->fsm);
 
 	if (ioc_st == BFA_IOC_ENABLING ||
 		ioc_st == BFA_IOC_FAIL || ioc_st == BFA_IOC_INITFAIL) {
 
-		iocpf_st = bfa_sm_to_state(iocpf_sm_table, ioc->iocpf.fsm);
+		iocpf_st = iocpf_sm_to_state(iocpf_sm_table, ioc->iocpf.fsm);
 
 		switch (iocpf_st) {
 		case BFA_IOCPF_SEMWAIT:
@@ -2983,7 +2983,7 @@ bfa_nw_iocpf_timeout(struct bfa_ioc *ioc)
 {
 	enum bfa_iocpf_state iocpf_st;
 
-	iocpf_st = bfa_sm_to_state(iocpf_sm_table, ioc->iocpf.fsm);
+	iocpf_st = iocpf_sm_to_state(iocpf_sm_table, ioc->iocpf.fsm);
 
 	if (iocpf_st == BFA_IOCPF_HWINIT)
 		bfa_ioc_poll_fwinit(ioc);
diff --git a/drivers/net/ethernet/brocade/bna/bfa_ioc.h b/drivers/net/ethernet/brocade/bna/bfa_ioc.h
index edd0ed5b5332..f30d06ec4ffe 100644
--- a/drivers/net/ethernet/brocade/bna/bfa_ioc.h
+++ b/drivers/net/ethernet/brocade/bna/bfa_ioc.h
@@ -147,16 +147,20 @@ struct bfa_ioc_notify {
 	(__notify)->cbarg = (__cbarg);				\
 } while (0)
 
+enum iocpf_event;
+
 struct bfa_iocpf {
-	bfa_fsm_t		fsm;
+	void (*fsm)(struct bfa_iocpf *s, enum iocpf_event e);
 	struct bfa_ioc		*ioc;
 	bool			fw_mismatch_notified;
 	bool			auto_recover;
 	u32			poll_time;
 };
 
+enum ioc_event;
+
 struct bfa_ioc {
-	bfa_fsm_t		fsm;
+	void (*fsm)(struct bfa_ioc *s, enum ioc_event e);
 	struct bfa		*bfa;
 	struct bfa_pcidev	pcidev;
 	struct timer_list	ioc_timer;
diff --git a/drivers/net/ethernet/brocade/bna/bfa_msgq.h b/drivers/net/ethernet/brocade/bna/bfa_msgq.h
index 75343b535798..170a4b4bed96 100644
--- a/drivers/net/ethernet/brocade/bna/bfa_msgq.h
+++ b/drivers/net/ethernet/brocade/bna/bfa_msgq.h
@@ -55,8 +55,10 @@ enum bfa_msgq_cmdq_flags {
 	BFA_MSGQ_CMDQ_F_DB_UPDATE	= 1,
 };
 
+enum cmdq_event;
+
 struct bfa_msgq_cmdq {
-	bfa_fsm_t			fsm;
+	void (*fsm)(struct bfa_msgq_cmdq *s, enum cmdq_event e);
 	enum bfa_msgq_cmdq_flags flags;
 
 	u16			producer_index;
@@ -81,8 +83,10 @@ enum bfa_msgq_rspq_flags {
 
 typedef void (*bfa_msgq_mcfunc_t)(void *cbarg, struct bfi_msgq_mhdr *mhdr);
 
+enum rspq_event;
+
 struct bfa_msgq_rspq {
-	bfa_fsm_t			fsm;
+	void (*fsm)(struct bfa_msgq_rspq *s, enum rspq_event e);
 	enum bfa_msgq_rspq_flags flags;
 
 	u16			producer_index;
diff --git a/drivers/net/ethernet/brocade/bna/bna_enet.c b/drivers/net/ethernet/brocade/bna/bna_enet.c
index a2c983f56b00..883de0ac8de4 100644
--- a/drivers/net/ethernet/brocade/bna/bna_enet.c
+++ b/drivers/net/ethernet/brocade/bna/bna_enet.c
@@ -1257,7 +1257,7 @@ bna_enet_mtu_get(struct bna_enet *enet)
 void
 bna_enet_enable(struct bna_enet *enet)
 {
-	if (enet->fsm != (bfa_sm_t)bna_enet_sm_stopped)
+	if (enet->fsm != bna_enet_sm_stopped)
 		return;
 
 	enet->flags |= BNA_ENET_F_ENABLED;
@@ -1751,12 +1751,12 @@ bna_ioceth_uninit(struct bna_ioceth *ioceth)
 void
 bna_ioceth_enable(struct bna_ioceth *ioceth)
 {
-	if (ioceth->fsm == (bfa_fsm_t)bna_ioceth_sm_ready) {
+	if (ioceth->fsm == bna_ioceth_sm_ready) {
 		bnad_cb_ioceth_ready(ioceth->bna->bnad);
 		return;
 	}
 
-	if (ioceth->fsm == (bfa_fsm_t)bna_ioceth_sm_stopped)
+	if (ioceth->fsm == bna_ioceth_sm_stopped)
 		bfa_fsm_send_event(ioceth, IOCETH_E_ENABLE);
 }
 
diff --git a/drivers/net/ethernet/brocade/bna/bna_tx_rx.c b/drivers/net/ethernet/brocade/bna/bna_tx_rx.c
index 2623a0da4682..c05dc7a1c4a1 100644
--- a/drivers/net/ethernet/brocade/bna/bna_tx_rx.c
+++ b/drivers/net/ethernet/brocade/bna/bna_tx_rx.c
@@ -1956,7 +1956,7 @@ static void
 bna_rx_stop(struct bna_rx *rx)
 {
 	rx->rx_flags &= ~BNA_RX_F_ENET_STARTED;
-	if (rx->fsm == (bfa_fsm_t) bna_rx_sm_stopped)
+	if (rx->fsm == bna_rx_sm_stopped)
 		bna_rx_mod_cb_rx_stopped(&rx->bna->rx_mod, rx);
 	else {
 		rx->stop_cbfn = bna_rx_mod_cb_rx_stopped;
@@ -2535,7 +2535,7 @@ bna_rx_destroy(struct bna_rx *rx)
 void
 bna_rx_enable(struct bna_rx *rx)
 {
-	if (rx->fsm != (bfa_sm_t)bna_rx_sm_stopped)
+	if (rx->fsm != bna_rx_sm_stopped)
 		return;
 
 	rx->rx_flags |= BNA_RX_F_ENABLED;
@@ -3523,7 +3523,7 @@ bna_tx_destroy(struct bna_tx *tx)
 void
 bna_tx_enable(struct bna_tx *tx)
 {
-	if (tx->fsm != (bfa_sm_t)bna_tx_sm_stopped)
+	if (tx->fsm != bna_tx_sm_stopped)
 		return;
 
 	tx->flags |= BNA_TX_F_ENABLED;
diff --git a/drivers/net/ethernet/brocade/bna/bna_types.h b/drivers/net/ethernet/brocade/bna/bna_types.h
index 666b6922e24d..a5ebd7110e07 100644
--- a/drivers/net/ethernet/brocade/bna/bna_types.h
+++ b/drivers/net/ethernet/brocade/bna/bna_types.h
@@ -312,8 +312,10 @@ struct bna_attr {
 
 /* IOCEth */
 
+enum bna_ioceth_event;
+
 struct bna_ioceth {
-	bfa_fsm_t		fsm;
+	void (*fsm)(struct bna_ioceth *s, enum bna_ioceth_event e);
 	struct bfa_ioc ioc;
 
 	struct bna_attr attr;
@@ -334,8 +336,10 @@ struct bna_pause_config {
 	enum bna_status rx_pause;
 };
 
+enum bna_enet_event;
+
 struct bna_enet {
-	bfa_fsm_t		fsm;
+	void (*fsm)(struct bna_enet *s, enum bna_enet_event e);
 	enum bna_enet_flags flags;
 
 	enum bna_enet_type type;
@@ -360,8 +364,10 @@ struct bna_enet {
 
 /* Ethport */
 
+enum bna_ethport_event;
+
 struct bna_ethport {
-	bfa_fsm_t		fsm;
+	void (*fsm)(struct bna_ethport *s, enum bna_ethport_event e);
 	enum bna_ethport_flags flags;
 
 	enum bna_link_status link_status;
@@ -454,13 +460,16 @@ struct bna_txq {
 };
 
 /* Tx object */
+
+enum bna_tx_event;
+
 struct bna_tx {
 	/* This should be the first one */
 	struct list_head			qe;
 	int			rid;
 	int			hw_id;
 
-	bfa_fsm_t		fsm;
+	void (*fsm)(struct bna_tx *s, enum bna_tx_event e);
 	enum bna_tx_flags flags;
 
 	enum bna_tx_type type;
@@ -698,8 +707,11 @@ struct bna_rxp {
 };
 
 /* RxF structure (hardware Rx Function) */
+
+enum bna_rxf_event;
+
 struct bna_rxf {
-	bfa_fsm_t		fsm;
+	void (*fsm)(struct bna_rxf *s, enum bna_rxf_event e);
 
 	struct bfa_msgq_cmd_entry msgq_cmd;
 	union {
@@ -769,13 +781,16 @@ struct bna_rxf {
 };
 
 /* Rx object */
+
+enum bna_rx_event;
+
 struct bna_rx {
 	/* This should be the first one */
 	struct list_head			qe;
 	int			rid;
 	int			hw_id;
 
-	bfa_fsm_t		fsm;
+	void (*fsm)(struct bna_rx *s, enum bna_rx_event e);
 
 	enum bna_rx_type type;
 
-- 
2.34.1

