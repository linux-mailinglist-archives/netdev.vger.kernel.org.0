Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D926722ABB0
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 11:22:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728282AbgGWJWl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 05:22:41 -0400
Received: from verein.lst.de ([213.95.11.211]:59401 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725846AbgGWJWl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jul 2020 05:22:41 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 12CCA68AFE; Thu, 23 Jul 2020 11:22:39 +0200 (CEST)
Date:   Thu, 23 Jul 2020 11:22:38 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     netdev@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>,
        Christoph Hellwig <hch@lst.de>, linux-sctp@vger.kernel.org
Subject: Re: [PATCH net-next] sctp: fix slab-out-of-bounds in
 SCTP_DELAYED_SACK processing
Message-ID: <20200723092238.GA21143@lst.de>
References: <5955bc857c93d4bb64731ef7a9e90cb0094a8989.1595450200.git.marcelo.leitner@gmail.com> <20200722204231.GA3398@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200722204231.GA3398@localhost.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 22, 2020 at 05:42:31PM -0300, Marcelo Ricardo Leitner wrote:
> Cc'ing linux-sctp@vger.kernel.org.

What do you think of this version, which I think is a little cleaner?


diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 9a767f35971865..6ce460428af9f3 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -2749,31 +2749,12 @@ static void sctp_apply_asoc_delayed_ack(struct sctp_sack_info *params,
  *    timer to expire.  The default value for this is 2, setting this
  *    value to 1 will disable the delayed sack algorithm.
  */
-
-static int sctp_setsockopt_delayed_ack(struct sock *sk,
-				       struct sctp_sack_info *params,
-				       unsigned int optlen)
+static int __sctp_setsockopt_delayed_ack(struct sock *sk,
+					 struct sctp_sack_info *params)
 {
 	struct sctp_sock *sp = sctp_sk(sk);
 	struct sctp_association *asoc;
 
-	if (optlen == sizeof(struct sctp_sack_info)) {
-		if (params->sack_delay == 0 && params->sack_freq == 0)
-			return 0;
-	} else if (optlen == sizeof(struct sctp_assoc_value)) {
-		pr_warn_ratelimited(DEPRECATED
-				    "%s (pid %d) "
-				    "Use of struct sctp_assoc_value in delayed_ack socket option.\n"
-				    "Use struct sctp_sack_info instead\n",
-				    current->comm, task_pid_nr(current));
-
-		if (params->sack_delay == 0)
-			params->sack_freq = 1;
-		else
-			params->sack_freq = 0;
-	} else
-		return -EINVAL;
-
 	/* Validate value parameter. */
 	if (params->sack_delay > 500)
 		return -EINVAL;
@@ -2821,6 +2802,31 @@ static int sctp_setsockopt_delayed_ack(struct sock *sk,
 	return 0;
 }
 
+static int sctp_setsockopt_delayed_ack(struct sock *sk,
+				       struct sctp_sack_info *params,
+				       unsigned int optlen)
+{
+	if (optlen == sizeof(struct sctp_assoc_value)) {
+		struct sctp_sack_info p;
+
+		pr_warn_ratelimited(DEPRECATED
+				    "%s (pid %d) "
+				    "Use of struct sctp_assoc_value in delayed_ack socket option.\n"
+				    "Use struct sctp_sack_info instead\n",
+				    current->comm, task_pid_nr(current));
+
+		memcpy(&p, params, sizeof(struct sctp_assoc_value));
+		p.sack_freq = p.sack_delay ? 0 : 1;
+		return __sctp_setsockopt_delayed_ack(sk, &p);
+	}
+
+	if (optlen != sizeof(struct sctp_sack_info))
+		return -EINVAL;
+	if (params->sack_delay == 0 && params->sack_freq == 0)
+		return 0;
+	return __sctp_setsockopt_delayed_ack(sk, params);
+}
+
 /* 7.1.3 Initialization Parameters (SCTP_INITMSG)
  *
  * Applications can specify protocol parameters for the default association
