Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 932C355D524
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:14:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240207AbiF0SgL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 14:36:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239253AbiF0Sfr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 14:35:47 -0400
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C585E08
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 11:30:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1656354636; x=1687890636;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BvdEY2kcjmkiLSIAoyKf24xtHwDnbh4LjAj8MAbvQ3s=;
  b=nm0MpSdhnN5C4fpUtlSE2PsWaLxad1Hdc9KAFQGPSxm1+RpoaBE3FxLa
   c4i2g7sPNl0IIM7jH9geN8XVIdc8k4rtRAp9/jUfzDvjPYTP46bs+qL/L
   5hbpqQapjmmH0WIMLjtdGKqdz7R86hwpYtlh2cxa/2pbfeUBTpQHS8hpo
   A=;
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1a-4ba5c7da.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP; 27 Jun 2022 18:30:22 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1a-4ba5c7da.us-east-1.amazon.com (Postfix) with ESMTPS id 69B8CC0A2C;
        Mon, 27 Jun 2022 18:30:20 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Mon, 27 Jun 2022 18:30:19 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.124) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Mon, 27 Jun 2022 18:30:16 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <kuba@kernel.org>
CC:     <davem@davemloft.net>, <ebiederm@xmission.com>,
        <edumazet@google.com>, <herbert@gondor.apana.org.au>,
        <kuni1840@gmail.com>, <kuniyu@amazon.com>,
        <netdev@vger.kernel.org>, <pabeni@redhat.com>, <xemul@openvz.org>
Subject: Re: [PATCH v2 net] af_unix: Do not call kmemdup() for init_net's sysctl table.
Date:   Mon, 27 Jun 2022 11:30:09 -0700
Message-ID: <20220627183009.94599-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220627105859.3ffec11a@kernel.org>
References: <20220627105859.3ffec11a@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.124]
X-ClientProxiedBy: EX13D38UWC004.ant.amazon.com (10.43.162.204) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Jakub Kicinski <kuba@kernel.org>
Date:   Mon, 27 Jun 2022 10:58:59 -0700
> On Sun, 26 Jun 2022 11:43:27 -0500 Eric W. Biederman wrote:
> > Kuniyuki Iwashima <kuniyu@amazon.com> writes:
> > 
> > > While setting up init_net's sysctl table, we need not duplicate the global
> > > table and can use it directly.  
> > 
> > Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
> > 
> > I am not quite certain the savings of a single entry table justivies
> > the complexity.  But the looks correct.
> 
> Yeah, the commit message is a little sparse. The "why" is not addressed.
> Could you add more details to explain the motivation?

I was working on a series which converts UDP/TCP hash tables into per-netns
ones like AF_UNIX to speed up looking up sockets.  It will consume much
memory on a host with thousands of netns, but it can be waste if we do not
have its protocol family's sockets.

So, I'm now working on a follow-up series for AF_UNIX per-netns hash table
so that we can change the size for a child netns by a sysctl knob:

  # sysctl -w net.unix.child_hash_entries=128
  # ip net add test  # created with the hash table size 128
  # ip net exec test sh
  # sysctl net.unix.hash_entries  # read-only
  128

  (The size for init_net can be changed via a new boot parameter
   xhash_entries like uhash_entries/thash_entries.)

While implementing that, I found that kmemdup() is called for init_net but
TCP/UDP does not (See: ipv4_sysctl_init_net()).  Unlike IPv4, AF_UNIX does
not have a huge sysctl table, so it cannot be a problem though, this patch
is for consuming less memory and kind of consistency.  The reason I submit
this seperately is that it might be better to have a Fixes tag.
