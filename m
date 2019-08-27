Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD5949E639
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 12:58:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726190AbfH0K56 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 06:57:58 -0400
Received: from mail-wm1-f49.google.com ([209.85.128.49]:53782 "EHLO
        mail-wm1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbfH0K56 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Aug 2019 06:57:58 -0400
Received: by mail-wm1-f49.google.com with SMTP id 10so2593028wmp.3
        for <netdev@vger.kernel.org>; Tue, 27 Aug 2019 03:57:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=WsMgWTmNV52F7I2YHnH5D4EeIks1Rn+8SOfW/bGaJoo=;
        b=L4lZy11oIuBAW4dpJeMH/CBKj/uuKrGqpo7g4357/oqvB3jNyYgHOn7AuVkmPS6GkE
         4uOjIRPQu93ROhcDIqZoz7P9xgxC1vNO8hPUc1EsTwoaQPCC9q8JpvYDxGhvs7tm6SLL
         orXnbK2HakhegnOACMUSC5Tx/f36plZn0hySTUiNZmV89nW8qVRc82z0ucID2QGPVKbJ
         hquR4xFKZQx+Xqi7ewbj16ePdBRNs2BZUDKs70ppmENVA6aepVaYlEAy2+TSld2ev7n3
         EUs1BSIfMbFNhY0QAPKWsyIBZQpJoDzltS5jIoNJvqXoae4N2wUz4EnK3ZnmSPKvbLZk
         KP2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=WsMgWTmNV52F7I2YHnH5D4EeIks1Rn+8SOfW/bGaJoo=;
        b=OzraKkcRYmhibB1UoiowlHQ7BYQe7/Y8tE4sPEpmjJJ1L+So84X5nQG5BdW+BwUGY1
         eHZ3GWlXRvA5Ghji5fpOZZUyVQS9KvuEhZW/enCtmK6SWGf92ZqAjcpWsAERvo10YeSo
         gDyNCWMpO9YqJ3/i24sqNzn/ZLl8QWbC25tPqd0zSIUx6DjoLloyaUSZqvLgaMu88Gb+
         d2wMcZzwDsjeiY3V0GM5yHMVGoBGUynZC3UPmUw8j1Yu1e/k8gkPYzPP+WlvIY2KOPoI
         KCyomg4dYHM9b11t6HZL2gFEDQMAm325pHQLJZC5LO4WsNfLZXS0OnnMpkB/le9pGPQk
         V3Tg==
X-Gm-Message-State: APjAAAV1qGHplHoUilwQvG0WUlPCxRIDYj2zsmPF10CDIejBfqGWnSfz
        C1bAoI2At1ccN9XrbeVNseg=
X-Google-Smtp-Source: APXvYqySwYUAtUXxRVJ5XuN5hD6mYuVC59FDtYUupx9WiZdPdetGFXbB+GkTuqe58DyR1Ccj1nkDjw==
X-Received: by 2002:a1c:cb0b:: with SMTP id b11mr28328519wmg.95.1566903476565;
        Tue, 27 Aug 2019 03:57:56 -0700 (PDT)
Received: from pixies (bzq-82-81-225-244.cablep.bezeqint.net. [82.81.225.244])
        by smtp.gmail.com with ESMTPSA id b26sm2014696wmj.14.2019.08.27.03.57.55
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 27 Aug 2019 03:57:55 -0700 (PDT)
Date:   Tue, 27 Aug 2019 13:57:54 +0300
From:   Shmulik Ladkani <shmulik.ladkani@gmail.com>
To:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netdev@vger.kernel.org, shmulik@metanetworks.com
Subject: [REGRESSION] netfilter: conntrack: Unable to change conntrack
 accounting of a net namespace via 'nf_conntrack_acct' sysfs
Message-ID: <20190827135754.7d460ef8@pixies>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Prior d912dec12428 ("netfilter: conntrack: merge acct and helper sysctl table with main one")
one was able to enable extended accounting within a (non-init)
net-namespace by setting: 'net.netfilter.nf_conntrack_acct=1'

However since d912dec12428, doing so results in changing init_net's
sysctl_acct field, instead of the relevant net's sysctl_acct.

Seen in original code, PRE d912dec12428, which creates a reference to
each net's _OWN_ ct.sysctl_acct within a separate acct_sysctl_table,
snip:

-static int nf_conntrack_acct_init_sysctl(struct net *net)
-{
-	struct ctl_table *table;
-
-	table = kmemdup(acct_sysctl_table, sizeof(acct_sysctl_table),
-			GFP_KERNEL);
-	if (!table)
-		goto out;
-
-	table[0].data = &net->ct.sysctl_acct;
-

(where 'nf_conntrack_acct_init_sysctl()' was originally called by
'nf_conntrack_acct_pernet_init()').

However POST d912dec12428, the per-net netfilter sysctl table simply
inherits from global 'nf_ct_sysctl_table[]', which has 

+		.data		= &init_net.ct.sysctl_acct,

effectivly making any 'net.netfilter.nf_conntrack_acct' sysctl change
affect the 'init_net' and not relevant net namespace.

Also, looks like "nf_conntrack_helper", "nf_conntrack_events",
"nf_conntrack_timestamp" where also harmed in a similar way, see:

  d912dec12428 ("netfilter: conntrack: merge acct and helper sysctl table with main one")
  cb2833ed0044 ("netfilter: conntrack: merge ecache and timestamp sysctl tables with main one")

Florian, would it be possible for you to revert these on -net ?

Many thanks,
Shmulik
