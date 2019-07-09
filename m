Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D293362D75
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 03:35:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726779AbfGIBe5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 21:34:57 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:36386 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725886AbfGIBe5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 21:34:57 -0400
Received: by mail-io1-f66.google.com with SMTP id o9so24073049iom.3
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 18:34:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=ffrsoN2BOlxqpxCes3YwnfFJPt6HpmU/FvgwSnurnw8=;
        b=rZTsbZkdYVy5wAVc+VtRUmnsfyobQAjx2WH8Ly14gBKb68HXb9jP9RAIpAUMnCn2+B
         NzDt5e45/tLchd5VJQp+K6E67XJYIgJG5mUA/uP2nAkrjkTAF4HufZcKKeh+gZo2LRXc
         wMAS3yz4XU2ENiIzC3laecdvtcxDJpX7jCvNeToZMeIsuR7GKd864Mkrspcurkk+tmvu
         XMvKwKsCgjLxPn4aqVvpdW3Gia/AFlzS63sJHOPpz5zEUdYdFcRN91wsXHN2XhgBSS6x
         cUWLrIbuiuHKg6yWRz6FrY2hQGOX064CiJMw2JpqI9S1YqeiGTb70hKcGIuYbhoWQxnj
         cudA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=ffrsoN2BOlxqpxCes3YwnfFJPt6HpmU/FvgwSnurnw8=;
        b=oLBPtr80GVF5b38UpOXUcsnt0/B5MWPb1te//nRHxZI5F7TXmlPqX0L1XlA1Nh/4P7
         mwUk+TZJfKiGhphbTS40mTw4kdVgmiUTgRPYrFB1mtEMOZTCKDJRDI8rdyXbPaacmSZ1
         MMgdEsR6JD8zByN+hG37W+XnjFu8XhQfrabGFGC0QO+2UA4QJFwCyk/7iHAwRgpZQmHy
         NBvneEvd4E9dEvWE8kJ5TJnYEByxV5LHBDlBzAGfr1JILTGPZLV7sekMiSVJx+E+teTK
         NWdLqDQqLyRIi2Z5f8jcj2XxR0T8Be8EKO1Lf+qHqYlB9izE+Eui0ep7h4wi/vxtPw7G
         9uOA==
X-Gm-Message-State: APjAAAVQx8PNivjXfwcZCh4nm40NQQxvAyzE7C7UuGys2CVXtPp+3Pcg
        z0FMZlh7zuTDlBwZsYirey4qdg==
X-Google-Smtp-Source: APXvYqxw+oL4fgimwYE6DgooAQ8iC3XcONLCPItE/nNLb2qwUy/0Yjdo0ByqIul3swsc8OEqeMdfOA==
X-Received: by 2002:a5d:8c87:: with SMTP id g7mr22520275ion.85.1562636096830;
        Mon, 08 Jul 2019 18:34:56 -0700 (PDT)
Received: from mojatatu.com ([2607:f2c0:e4b2:adf:80be:fc0b:d6c4:7dbc])
        by smtp.gmail.com with ESMTPSA id n17sm17894248iog.63.2019.07.08.18.34.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 08 Jul 2019 18:34:56 -0700 (PDT)
From:   Lucas Bates <lucasb@mojatatu.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, mleitner@redhat.com, vladbu@mellanox.com,
        dcaratti@redhat.com, kernel@mojatatu.com,
        Lucas Bates <lucasb@mojatatu.com>
Subject: [PATCH net-next 0/2] tc-testing: Add plugin for simple traffic generation
Date:   Mon,  8 Jul 2019 21:34:25 -0400
Message-Id: <1562636067-1338-1-git-send-email-lucasb@mojatatu.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series supersedes the previous submission that included a patch for test
case verification using JSON output.  It adds a new tdc plugin, scapyPlugin, as
a way to send traffic to test tc filters and actions.

The first patch makes a change to the TdcPlugin module that will allow tdc
plugins to examine the test case currently being executed, so plugins can
play a more active role in testing by accepting information or commands from
the test case.  This is required for scapyPlugin to work.

The second patch adds scapyPlugin itself, and an example test case file to
demonstrate how the scapy block works in the test cases.

Lucas Bates (2):
  tc-testing: Allow tdc plugins to see test case data
  tc-testing: introduce scapyPlugin for basic traffic

 tools/testing/selftests/tc-testing/TdcPlugin.py    |  5 +-
 .../creating-testcases/scapy-example.json          | 98 ++++++++++++++++++++++
 .../selftests/tc-testing/plugin-lib/scapyPlugin.py | 51 +++++++++++
 tools/testing/selftests/tc-testing/tdc.py          | 10 +--
 4 files changed, 156 insertions(+), 8 deletions(-)
 create mode 100644 tools/testing/selftests/tc-testing/creating-testcases/scapy-example.json
 create mode 100644 tools/testing/selftests/tc-testing/plugin-lib/scapyPlugin.py

--
2.7.4

