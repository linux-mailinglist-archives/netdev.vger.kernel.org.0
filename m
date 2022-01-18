Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41708493006
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 22:33:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343985AbiARVdP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 16:33:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343490AbiARVdO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 16:33:14 -0500
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2952FC061574
        for <netdev@vger.kernel.org>; Tue, 18 Jan 2022 13:33:14 -0800 (PST)
Received: by mail-qk1-x735.google.com with SMTP id t1so554813qkt.11
        for <netdev@vger.kernel.org>; Tue, 18 Jan 2022 13:33:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:subject:message-id:mime-version:content-disposition;
        bh=PLtdkBcM981EO7/83QHNB4NkwiQXlhUcsB0x6VqDy1k=;
        b=LkrtJ8Rr1WJeXehRRO0ne+FY7gld2+c+acv9787TY3YsT3dmBydd46LYm2UaM7PQ57
         iZuRrU/2pOet/UxESNjWWFSk/NSEEPazttw1KVmmmNWOk570h1Q0ibN+gizNuWzjbIuw
         cLAbePpA+4viKFy509c5YlhHAKjuUWOCY3SqY2jq5Q4eN6RJWu8eSoahCwgDQWMsKTnC
         aa3ahADp3mVrs9W0O9KDIkq5XDx/aLu4F2zgFHpXTYNbve0vDL4IIED3hDMRhXHLsxk7
         ZinnhHjf3oxELytbe0qIIYpuil5rdcJHaanuKaqrUXEoI7VFiCQVCfWwL420CCH3LFO0
         IiPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-disposition;
        bh=PLtdkBcM981EO7/83QHNB4NkwiQXlhUcsB0x6VqDy1k=;
        b=JwHV+1/3G49jHnWUq1+IkchwLMnDo1DCeU0UcGc+8OY6E2jxg2bVlGyjskuqAHqvL1
         bruNqpYw67aXUXlq84LRgLbG92dJto3UStSsV18JHR9uADtsEOdgjwK0eDkzg9yXVnHd
         OvK56wGeq04E/HCr3LowpiO0fA5M8ioQ8tDq3h5h1C4CNPnZuJDWl3ptPOaSu+2PPXFb
         2HWQ0PIYSyG+1gyO+x7lk4Q80xuS21QGzD8n/NTMtnqheDKpW0gCohAU1bzwXRAjLqyU
         hg9qzreNODfTLWv9AEkjYHbXnt+fcydJxXx9Mnrh41eGBQ+QcEIPZqx6JxGp9TlffHYG
         7LWw==
X-Gm-Message-State: AOAM531C57OKuNsl2r+D68tAp/gCO7Si8S1EQnmUu51Z+STL45YzRTCd
        QXT3/OxluFSGGX5SSF2MwUNTQZhKJA==
X-Google-Smtp-Source: ABdhPJzPyYOMdmwCSUcNRBePO2Z+D7JfkScOEwknFmKl7aOsfNBq6bNcQG2VTumSto10ZW+o05dZPA==
X-Received: by 2002:a37:848:: with SMTP id 69mr18999329qki.638.1642541593113;
        Tue, 18 Jan 2022 13:33:13 -0800 (PST)
Received: from ICIPI.localdomain ([136.56.65.87])
        by smtp.gmail.com with ESMTPSA id v1sm11369411qtc.95.2022.01.18.13.33.12
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jan 2022 13:33:12 -0800 (PST)
Date:   Tue, 18 Jan 2022 16:33:04 -0500
From:   Stephen Suryaputra <ssuryaextr@gmail.com>
To:     netdev@vger.kernel.org
Subject: GRE non-zero TTL and DF=1
Message-ID: <20220118213248.GA12520@ICIPI.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I'm trying to pinpoint the exact scenario that is being prevented by the
decision to set DF=1 when the tunnel parameter ttl is non-zero, i.e. in
this code snippet:

int ip_tunnel_ctl(struct net_device *dev, struct ip_tunnel_parm *p, int cmd)
{
	...
	switch (cmd) {
	...
	case SIOCADDTUNNEL:
	case SIOCCHGTUNNEL:
		...
		if (p->iph.ttl)
			p->iph.frag_off |= htons(IP_DF);
	...
	}
	...
}

There is a comment in ip_gre.c that it is to prevent recursive network
loop:

   "One of them is to parse packet trying to detect inner encapsulation
   made by our node. It is difficult or even impossible, especially,
   taking into account fragmentation. TO be short, ttl is not solution at all.

   Current solution: The solution was UNEXPECTEDLY SIMPLE.
   We force DF flag on tunnels with preconfigured hop limit,
   that is ALL. :-) Well, it does not remove the problem completely,
   but exponential growth of network traffic is changed to linear
   (branches, that exceed pmtu are pruned) and tunnel mtu
   rapidly degrades to value <68, where looping stops.
   Yes, it is not good if there exists a router in the loop,
   which does not force DF, even when encapsulating packets have DF set.
   But it is not our problem! Nobody could accuse us, we made
   all that we could make. Even if it is your gated who injected
   fatal route to network, even if it were you who configured
   fatal static route: you are innocent. :-)"

It seems to read that when there is a fragmentation, the inner
encapsulation is lost of non-first fragments, but my problems are:
1) I don't see where the inner encapsulation by the self node is being
   detected.
2) I don't understand how the tunnel mtu can degrades. In the case of
   looping, the mtu stays the same and packet is being recursively
   encapsulated and in the end the packets contain only the headers, but
   it's still looping forever (in the absence of the detection in (1)).
3) If (1) exists, then I think the looping is finite, e.g. eventually
   the node that tunnels will detect itself even in the presence of
   fragmentation because the non-first fragments is GRE encapsulated by the
   self node again.

Any example topology and scenarios that can shed lights into what the
comment concerns about? What am I missing?

Thanks,
Stephen.
