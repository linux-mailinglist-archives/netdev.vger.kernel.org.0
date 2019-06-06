Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08F9637F9E
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 23:32:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728048AbfFFVcd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 17:32:33 -0400
Received: from mail-it1-f193.google.com ([209.85.166.193]:53635 "EHLO
        mail-it1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727057AbfFFVcd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 17:32:33 -0400
Received: by mail-it1-f193.google.com with SMTP id m187so2370147ite.3
        for <netdev@vger.kernel.org>; Thu, 06 Jun 2019 14:32:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=0UBp8IuexxJSj3blr1CLweJjhAw9wYh5RXbDp8gDoEk=;
        b=irfdI4L9q0TTqaBXA0KHknjq5dE5ProARR4PRIsJyDMSFBV1lS+Lae7XJryQjRDVg/
         x+UC5XWOZNtzZO/gKXVU2bGpeqR9V+D8CtRNp+Sc4SD2ZM5kL4imPKhJ+SxYnAUOIxI5
         /j7FvDw9j3zsZHFbxrpAhdw2GIyEghMrU8mQgTzD59XkwRhj2Rwi29VxOQEzpbqFxhxm
         WYHFyRtRXxsbczTsuZshfK0M4fzBr/uXoLWp5B+gPmPJXQDCjkUUVCINdGaK/HNnmudv
         zbo2M3yKgFv6aQlJyN4UKR1UUx76zlJaKXfVgqHGVqmsrz+XCpSlTbmq5uxQ6Q/83xH5
         ZPNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=0UBp8IuexxJSj3blr1CLweJjhAw9wYh5RXbDp8gDoEk=;
        b=FEj/G8twmYGlyDU3PT8Sja1a7qkO5GBI2UP0IWNLUCQ5596cTOCSxAGmm6xynARVDw
         pWYDY608VlcuBB4FVayFr31bhtCVLWjj7RtEsDW5ZjRblgKZ7wwys8HrHDDcFkks+xEs
         aGo76pqeDe5KPvuqujYSjz9JYU23IcITzRWGO84zq+rGP5Q0b5u6SBat17wkWiiBMGL1
         pdT5hlml1xvcskEmkB946oI3j41bPR/a58OrkzRxCVaxW1IY243dcfkj1cIYXKXBRbBU
         1SQlDDOY5d1/EBbiciU/QzwC6U1WrnztkCPluherbw84uDUvKH4UpMQCBXyTc48cQr0w
         SFTA==
X-Gm-Message-State: APjAAAVjEPn4sASzZXMH1C75lS8xyp+M6LViAH4AxL5curT17vPmBp61
        FcylubZpJ+cjAS4mEpARIzBVRo1zAGY=
X-Google-Smtp-Source: APXvYqy1hUnoHRA04WJa1BSBkD0xFqSttKn/tvIzgC6BPq5UhnIyXCxUKNWdp59ttQxQVi2p/7rBDg==
X-Received: by 2002:a24:1c13:: with SMTP id c19mr1651882itc.93.1559856752744;
        Thu, 06 Jun 2019 14:32:32 -0700 (PDT)
Received: from mojatatu.com ([74.127.211.222])
        by smtp.gmail.com with ESMTPSA id y134sm1677228ity.40.2019.06.06.14.32.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 06 Jun 2019 14:32:32 -0700 (PDT)
From:   Roman Mashak <mrv@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     kernel@mojatatu.com, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, Roman Mashak <mrv@mojatatu.com>
Subject: [PATCH iproute2 1/1] tc: Fix binding of gact action by index.
Date:   Thu,  6 Jun 2019 17:32:09 -0400
Message-Id: <1559856729-32376-1-git-send-email-mrv@mojatatu.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following operation fails:
% sudo tc actions add action pipe index 1
% sudo tc filter add dev lo parent ffff: \
       protocol ip pref 10 u32 match ip src 127.0.0.2 \
       flowid 1:10 action gact index 1

Bad action type index
Usage: ... gact <ACTION> [RAND] [INDEX]
Where:  ACTION := reclassify | drop | continue | pass | pipe |
                  goto chain <CHAIN_INDEX> | jump <JUMP_COUNT>
        RAND := random <RANDTYPE> <ACTION> <VAL>
        RANDTYPE := netrand | determ
        VAL : = value not exceeding 10000
        JUMP_COUNT := Absolute jump from start of action list
        INDEX := index value used

However, passing a control action of gact rule during filter binding works:

% sudo tc filter add dev lo parent ffff: \
       protocol ip pref 10 u32 match ip src 127.0.0.2 \
       flowid 1:10 action gact pipe index 1

Binding by reference, i.e. by index, has to consistently work with
any tc action.

Since tc is sensitive to the order of keywords passed on the command line,
we can teach gact to skip parsing arguments as soon as it sees 'gact'
followed by 'index' keyword. 

Signed-off-by: Roman Mashak <mrv@mojatatu.com>
---
 tc/m_gact.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tc/m_gact.c b/tc/m_gact.c
index a0a3c33d23da..5b781e16446d 100644
--- a/tc/m_gact.c
+++ b/tc/m_gact.c
@@ -89,6 +89,9 @@ parse_gact(struct action_util *a, int *argc_p, char ***argv_p,
 
 	if (!matches(*argv, "gact"))
 		NEXT_ARG_FWD();
+	/* we're binding existing gact action to filter by index. */
+	if (!matches(*argv, "index"))
+		goto skip_args;
 	if (parse_action_control(&argc, &argv, &p.action, false))
 		usage();	/* does not return */
 
@@ -133,6 +136,7 @@ parse_gact(struct action_util *a, int *argc_p, char ***argv_p,
 
 	if (argc > 0) {
 		if (matches(*argv, "index") == 0) {
+skip_args:
 			NEXT_ARG();
 			if (get_u32(&p.index, *argv, 10)) {
 				fprintf(stderr, "Illegal \"index\"\n");
-- 
2.7.4

