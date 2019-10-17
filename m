Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EF50DB67C
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 20:44:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392717AbfJQSoQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 14:44:16 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:39973 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732180AbfJQSoP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 14:44:15 -0400
Received: by mail-lf1-f65.google.com with SMTP id f23so2707634lfk.7
        for <netdev@vger.kernel.org>; Thu, 17 Oct 2019 11:44:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=EIc6KspYNnaDFn8k5WBx7KzZDagn/0U09jdXM8cZ1iY=;
        b=nPCmAyrhKc7h3JzUt5ZeTIyArdNERq0A7kLIWfiGFGMmcarrOaQ8c9pNqIEOUfc4d2
         DZ/ovmHFhmqm/St1lE3FD5C+tWE80bRofU/F8htnOE3WbzIW+MasIQD/2rFABDEMJM/W
         VtjbOFqVBxJB+QtEmOPgkWOZ2XBZpJV46qLsT0AEWZN134D9u3qDxRBRB5A8yiT879EZ
         dlp7l7PJxMXhgCc1BDqJyWsudRjGIluSxuDZ7uVf4rR+gVcBLWx/yAJJ964r9C1IhMWp
         x+UcIcpR7WKM9DIDRb6fMtkDps3NUKPBKu7xxv8/YtUe1c8nUX7geI3feZtpnQ3iqIK8
         1qYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=EIc6KspYNnaDFn8k5WBx7KzZDagn/0U09jdXM8cZ1iY=;
        b=fSYK15RO/fPHOW6NUfo6cITBJCthj0Z8QMbG1uQ8uq85cw3fL848uadUcOg7c1iWgS
         E3LL5sL2dcJ2aiuxpIzaoS048Fuxnp8bj7OUtVcB8N9RnLYev7WhEDS79dw4lMv7+Iyz
         ArmKCbV6ZCFXTMGh623ncitINcsdhp+8CQevLUgFGU6QLsL5WkcF7KpTtts1OnuwrD/j
         QZuYmJk5ahmczw5YL2O4vbN+bEpLfUEvkEGjzI6KbsWLVL24N7kUOvW9oKQWw6E3cHL2
         nDv30MQMrFpMFHvteA6z0p32z+UZ7pBREF9gYr/Ni/bDdHS9lilwGXGV90Gv9gwvTRkd
         k6ug==
X-Gm-Message-State: APjAAAWqvDfwsTVGVTKRbpI4J7kQbU9jlNUs4nG1KHra47mLV77Ui3qr
        Qw8u3hkEP5TEGUNUUvEPUmMekQ==
X-Google-Smtp-Source: APXvYqyy0KQv1uRfgmxFxxAxb4Zeup81JsJvAXUnCLwHbDBG1PkDZR6ywHa2e85T49QSs9TqgUSZAA==
X-Received: by 2002:a19:655b:: with SMTP id c27mr3329500lfj.122.1571337853524;
        Thu, 17 Oct 2019 11:44:13 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id j7sm1483399lfc.16.2019.10.17.11.44.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Oct 2019 11:44:13 -0700 (PDT)
Date:   Thu, 17 Oct 2019 11:44:04 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        oss-drivers@netronome.com,
        Stephen Hemminger <stephen@networkplumber.org>,
        kbuild test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        Simon Horman <simon.horman@netronome.com>
Subject: Re: [PATCH net] net: netem: fix error path for corrupted GSO frames
Message-ID: <20191017114404.4fb502c6@cakuba.netronome.com>
In-Reply-To: <CAM_iQpW=S+UarEKCtL6q_ZyxVn0chVLgXQyfRNP_Kw-P8_Qt+Q@mail.gmail.com>
References: <20191016160050.27703-1-jakub.kicinski@netronome.com>
        <CAM_iQpXw7xBTGctD2oLdWGZHc+mpeUAMq5Z4AYvKSiw68e=5EQ@mail.gmail.com>
        <20191016162210.5f2a8256@cakuba.netronome.com>
        <CAM_iQpW=S+UarEKCtL6q_ZyxVn0chVLgXQyfRNP_Kw-P8_Qt+Q@mail.gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 17 Oct 2019 11:10:06 -0700, Cong Wang wrote:
> On Wed, Oct 16, 2019 at 4:22 PM Jakub Kicinski wrote:
> > On Wed, 16 Oct 2019 15:42:28 -0700, Cong Wang wrote:  
> > > > @@ -612,7 +613,7 @@ static int netem_enqueue(struct sk_buff *skb, struct Qdisc *sch,
> > > >                         }
> > > >                         segs = skb2;
> > > >                 }
> > > > -               qdisc_tree_reduce_backlog(sch, -nb, prev_len - len);
> > > > +               qdisc_tree_reduce_backlog(sch, !skb - nb, prev_len - len);  
> > >
> > > Am I the only one has trouble to understand the expression
> > > "!skb - nb"?  
> >
> > The backward logic of qdisc_tree_reduce_backlog() always gives me a
> > pause :S  
> 
> Yeah, reducing with a negative value is actually an add. Feel free
> to add a wrapper for this if you think it is better.

I was avoiding adding the wrapper due to stable, but perhaps it should
be okay.

How does this look?

--->8--------------

diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index 637548d54b3e..66c2dc6a4742 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -630,6 +630,13 @@ void qdisc_reset(struct Qdisc *qdisc);
 void qdisc_put(struct Qdisc *qdisc);
 void qdisc_put_unlocked(struct Qdisc *qdisc);
 void qdisc_tree_reduce_backlog(struct Qdisc *qdisc, int n, int len);
+
+static inline void
+qdisc_tree_increase_backlog(struct Qdisc *qdisc, int n, int len)
+{
+	qdisc_tree_reduce_backlog(qdisc, -n, -len);
+}
+
 #ifdef CONFIG_NET_SCHED
 int qdisc_offload_dump_helper(struct Qdisc *q, enum tc_setup_type type,
 			      void *type_data);
diff --git a/net/sched/sch_netem.c b/net/sched/sch_netem.c
index 0e44039e729c..e22c13b56bfc 100644
--- a/net/sched/sch_netem.c
+++ b/net/sched/sch_netem.c
@@ -509,6 +509,7 @@ static int netem_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 		if (skb->ip_summed == CHECKSUM_PARTIAL &&
 		    skb_checksum_help(skb)) {
 			qdisc_drop(skb, sch, to_free);
+			skb = NULL;
 			goto finish_segs;
 		}
 
@@ -592,10 +593,13 @@ static int netem_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 
 finish_segs:
 	if (segs) {
-		unsigned int len, last_len;
+		unsigned int last_len, len = 0;
 		int nb = 0;
 
-		len = skb->len;
+		if (skb) {
+			len += skb->len;
+			nb++;
+		}
 
 		while (segs) {
 			skb2 = segs->next;
@@ -612,7 +616,8 @@ static int netem_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 			}
 			segs = skb2;
 		}
-		qdisc_tree_reduce_backlog(sch, -nb, prev_len - len);
+		/* Parent qdiscs accounted for 1 skb of size @prev_len */
+		qdisc_tree_increase_backlog(sch, nb - 1, len - prev_len);
 	}
 	return NET_XMIT_SUCCESS;
 }
