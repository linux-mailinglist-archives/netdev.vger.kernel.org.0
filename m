Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6806520A8A0
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 01:12:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407707AbgFYXMy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 19:12:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403984AbgFYXMx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 19:12:53 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98630C08C5C1;
        Thu, 25 Jun 2020 16:12:53 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id h4so7909741ior.5;
        Thu, 25 Jun 2020 16:12:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:user-agent:mime-version
         :content-transfer-encoding;
        bh=Ek8CKvdDOC2Q7NyNkHtG/4mLEdguj/v9CWZ1O8dGEhM=;
        b=m3/aQaw1M/QUNEp3P3mGHlxz9ijrOrfIajkUCaLMnVB7o0UWf9NXN37QwundLTjqgG
         laPGkKlYxFQq5LORAHsLh4lJYR+K3TwQRcj1l7S6gDEUuzVSSqrAi2FfYFkBXLBKe7CH
         HUdONNMiKZaVaaeG2+4ROwN16DJIuWfqFvP3XULTpQas6BLp95cLyNY0w4O3oUt+OzHx
         jmPqERBb/4paun0uewupPSuLtwUicl87pxngHb5ULXkFLh7Qo3AtFgQ6aP1i09x1LYCt
         BgeuSpsnnKPsa5Dm5dVCiWpwcdDe+uCz21snyZDrE6v78EZQr8nWEmeADXYxB3II5Z2Y
         Q2WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=Ek8CKvdDOC2Q7NyNkHtG/4mLEdguj/v9CWZ1O8dGEhM=;
        b=rGKbkP+JrHop0Ttr8HWNXFrgxxHW0rgV7RKefoLG1GU1IY+k2kd0jxTIpZONhkOpcX
         GxRZMlg/V8ZruSTA2HLNv4QHk9jCvz1BsEyYy3e0Jd0nFVPQZ5TymNl72lMI0kBLJPdC
         gOUGeZ4J4VmuT9TmnmxroI3RBiJnMskTFzhPzA4Png842qjZupqhmSYeiPB4TV8sMk6i
         hUb59b2jDdf5b+6XBnrUjfrl6s0EiGdzJrev8SkeRDawRaxLCw4skzz2MQgj39DAkWFE
         izgiYWLo6oFPJ3Fh9cMUzWNQTF5jsJtqUzLAwxkB1k98lBS3LTdGgOpBgo5J7XPyoMSK
         xiBQ==
X-Gm-Message-State: AOAM531xwS46kF95ormgkTYRDGMOpQYoWlpdjMjeuaoAtBEi69qBQER1
        7SwCvfjQcb0B6sE+GmXn+qs=
X-Google-Smtp-Source: ABdhPJxT6azVM2zrAejQXLvFu1brUueJ77RajFtEfWLiQ7KJSwT3sGzfVDEQl68TEv3OiNPQUKrjUg==
X-Received: by 2002:a6b:8f09:: with SMTP id r9mr504257iod.168.1593126773025;
        Thu, 25 Jun 2020 16:12:53 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id u185sm2639222ilc.24.2020.06.25.16.12.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2020 16:12:52 -0700 (PDT)
Subject: [bpf PATCH v2 0/3] Sockmap RCU splat fix 
From:   John Fastabend <john.fastabend@gmail.com>
To:     kafai@fb.com, jakub@cloudflare.com, daniel@iogearbox.net,
        ast@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        john.fastabend@gmail.com
Date:   Thu, 25 Jun 2020 16:12:38 -0700
Message-ID: <159312606846.18340.6821004346409614051.stgit@john-XPS-13-9370>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix a splat introduced by recent changes to avoid skipping ingress policy
when kTLS is enabled. The RCU splat was introduced because in the non-TLS
case the caller is wrapped in an rcu_read_lock/unlock. But, in the TLS
case we have a reference to the psock and the caller did not wrap its
call in rcu_read_lock/unlock.

To fix extend the RCU section to include the redirect case which was
missed. From v1->v2 I changed the location a bit to simplify the code
some. See patch 1.

But, then Martin asked why it was not needed in the non-TLS case. The
answer for patch 1 was, as stated above, because the caller has the
rcu read lock. However, there was still a missing case where a BPF
user could in-theory line up a set of parameters to hit a case
where the code was entered from strparser side from a different context
then the initial caller. To hit this user would need a parser program
to return value greater than skb->len then an ENOMEM error could happen
in the strparser codepath triggering strparser to retry from a workqueue
and without rcu_read_lock original caller used. See patch 2 for details.

Finally, we don't actually have any selftests for parser returning a
value geater than skb->len so add one in patch 3. This is especially
needed because at least I don't have any code that uses the parser
to return value greater than skb->len. So I wouldn't have caught any
errors here in my own testing.

Thanks, John

v1->v2: simplify code in patch 1 some and add patches 2 and 3.

---

John Fastabend (3):
      bpf, sockmap: RCU splat with redirect and strparser error or TLS
      bpf, sockmap: RCU dereferenced psock may be used outside RCU block
      bpf, sockmap: Add ingres skb tests that utilize merge skbs


 net/core/skmsg.c                                   |   23 +++++++++++++-------
 .../selftests/bpf/progs/test_sockmap_kern.h        |    8 ++++++-
 tools/testing/selftests/bpf/test_sockmap.c         |   18 ++++++++++++++++
 3 files changed, 40 insertions(+), 9 deletions(-)

--
Signature
