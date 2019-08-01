Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCE637E67A
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 01:41:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388531AbfHAXly (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 19:41:54 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:34990 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732215AbfHAXlx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Aug 2019 19:41:53 -0400
Received: by mail-pg1-f196.google.com with SMTP id s1so28750132pgr.2
        for <netdev@vger.kernel.org>; Thu, 01 Aug 2019 16:41:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=c7FbA04GIwJMueyFAEPRW6KitrxUTvosPOKtwyVuHGQ=;
        b=JgoqKJm87nz32eXbDJtOncd+QiCnHY5WBcdMBFybs42XzfS/W7OQOq876nPr8SyfJi
         oGMkx9aSK3+REBcZCRs94197hS85yrjPVznrI7LXidN99KIh/jrZCKB3jzwksxmPjWqc
         phfcAUCvwCc2eC8PGk8tqRV1dsnkdna+jFyJ6H5rD0M+9sYX+/5c/l9i/1WKznxpkNpn
         wzQRFsRcZBX7q2yyRQRu/VlWFrntVmsFAq4S4oInYVznyynEgWl+id3NkxQdEtBTXClc
         3y152PGQdro0yETt8wsrhaIsfq9EUxavkXSe1ngxTUaurXrqJ3JKBEBETMlYzMJAXSXL
         YdQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=c7FbA04GIwJMueyFAEPRW6KitrxUTvosPOKtwyVuHGQ=;
        b=td7CHs2m/mmICCBbjrf/sRyAZyst2iB2LAJ/sl4bzzg3rCPbtjd0bhpnth9aeclWDj
         AcorzNlBjS6zwdJxkJOHHM6AfSdOGwZYavWXBhOM5B2xhB1vKBjPHatd4CpFVwsRQL56
         1UepczaM9F5JdSKRV0zFw5RFvS4Zbgo9SjHexlqLnbZV1szsI3XShOlK8xkhP6qvizev
         1NDbtiYhp3jRbjicFJ+T5QSCPGnE3Mn/opAaa7VqpRaGL/ewTNIXW5Q+5Y+9xnhkI0no
         OFe3umlySTJkL0laeKn16TnIOzRv4uAjVezG6cCX2gPTk3xJessdUXDH/aO0/Ggwq7g6
         Fkpg==
X-Gm-Message-State: APjAAAUYt8vFngDcXEdP9Zi1bgV5Ma/XrHeUNI8g5TNDeIKv3F5mQ7Q1
        5Rn3NHpSsvHNpgX4hIWdk099RaKFWD2oVUQ1PCFq3Ypf
X-Google-Smtp-Source: APXvYqxhRPVPt5ta7TCzyRI8uVKspmkg+jAyrmzK4aSDnJmPRd7Yg43bc3qMlijChZ86pTUTe/B8Bl4ilEuoknqI5mg=
X-Received: by 2002:a63:5811:: with SMTP id m17mr51080945pgb.237.1564702913152;
 Thu, 01 Aug 2019 16:41:53 -0700 (PDT)
MIME-Version: 1.0
References: <1564664571-31508-1-git-send-email-dmitrolin@mellanox.com>
In-Reply-To: <1564664571-31508-1-git-send-email-dmitrolin@mellanox.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 1 Aug 2019 16:41:41 -0700
Message-ID: <CAM_iQpVb_BLCna0Thi+84sHS-Wp3T0AGh6Wb9j6k8DefSEDGfA@mail.gmail.com>
Subject: Re: [PATCH] net: sched: use temporary variable for actions indexes
To:     dmitrolin@mellanox.com
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jiri Pirko <jiri@resnulli.us>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Vlad Buslov <vladbu@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 1, 2019 at 6:03 AM <dmitrolin@mellanox.com> wrote:
>
> From: Dmytro Linkin <dmitrolin@mellanox.com>
>
> Currently init call of all actions (except ipt) init their 'parm'
> structure as a direct pointer to nla data in skb. This leads to race
> condition when some of the filter actions were initialized successfully
> (and were assigned with idr action index that was written directly
> into nla data), but then were deleted and retried (due to following
> action module missing or classifier-initiated retry), in which case
> action init code tries to insert action to idr with index that was
> assigned on previous iteration. During retry the index can be reused
> by another action that was inserted concurrently, which causes
> unintended action sharing between filters.
> To fix described race condition, save action idr index to temporary
> stack-allocated variable instead on nla data.
>
> Fixes: 0190c1d452a9 ("net: sched: atomically check-allocate action")
> Signed-off-by: Dmytro Linkin <dmitrolin@mellanox.com>
> Signed-off-by: Vlad Buslov <vladbu@mellanox.com>


Acked-by: Cong Wang <xiyou.wangcong@gmail.com>

This is a sad side-effect we have to deal with for this retry logic,
we have to restore all global status in each retry loop. :-(

Thanks.
