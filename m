Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7454575769
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 00:11:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240922AbiGNWLZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 18:11:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232684AbiGNWLY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 18:11:24 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C37C570985
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 15:11:23 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id z25so5054402lfr.2
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 15:11:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=ouoO0HNdkV7+wxLmrSr9jjdwanqIiW8o9XNJUhNKzVk=;
        b=jrz9Yom+sYAH9lrmAHlHOk/D7F9amtLcjc007nbeuwhnO9+x+wD/A70E6R/2TqTYyT
         rwzotx3vHuITPhYaJ+Lv1Z7bjIJYQrbwQ9sjOTAUfRdmX7yCUxb/sntrTU9ithEgvERF
         CH1F0JkwVxrsxSQeWJh4d9DAtxanxpLJWRCWv0tM/UU2DdVjIq91VQURMnZ3Ggxq6OMq
         4Ce2aIU7d9FhSOgpzZ/WDS2FSqiC6KtKIqFmU0Hqd6lDlf60nd3nhPe5amp1hExRDYAH
         gOifGRf4q5ZDiYPtfCMpepeydmgr58DtBLDyml15NdXs9JEGPs4hoZoHUrwcdZyIcVxO
         dhcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=ouoO0HNdkV7+wxLmrSr9jjdwanqIiW8o9XNJUhNKzVk=;
        b=w7jpAmxe8rGOBibXuTNN4Xw1wUHF0ylAFxghTp2QO9KwVBQ7Bsq9yZ1zli3VhwfZwS
         MMzUTNr+lc35X0ES6CH0dwBC1oIvePx0KmaAVM/Uis9vmwEHQ+1uKrqwJ45Fk1RV58Uf
         EirU9PaN9HRuEdikGth6us1o78CAG31sTWV18QZCSFsNpf4txbQIZb+DgPKSGHXjSx0v
         GHCeMKS1AtnUsJo0I0AVU8Ylu7pXoGol0wUfEHddlqVnYzyrECqGOLeeZPKd7mopuXkh
         Kcw5FXSkrSuStr4bnw6Obd7I09T3a+9YL1Sx16fgpeb4ymwmVf4cVGnLLh+o3Oy9Wbjs
         wTgQ==
X-Gm-Message-State: AJIora8Ccx6ijIqF9uo4Er3cHt8zJRaeURZ+oyhesHn9gpm6gK2e81IQ
        gaFlRCdQbkqTxPuleXrK1InPkH/q014m59FhIOdfo6tsBeSuzQ==
X-Google-Smtp-Source: AGRyM1uonTmWaxL0Kwx6co2L6jOXGFaYLq2HKmJajpe73SeP4P/bam4QbQLXyC27CZnyQuDiOJe7sxO+YA/+CM1vA+U=
X-Received: by 2002:a05:6512:3e08:b0:489:d3c3:e901 with SMTP id
 i8-20020a0565123e0800b00489d3c3e901mr5961960lfv.125.1657836681948; Thu, 14
 Jul 2022 15:11:21 -0700 (PDT)
MIME-Version: 1.0
From:   Alexander Babayants <babayants.alexander@gmail.com>
Date:   Fri, 15 Jul 2022 01:11:12 +0300
Message-ID: <CAB92dJZM9K+Z3URB0F+S0B2yEHNSyjG1G9kTvCiWKYigh5FdpA@mail.gmail.com>
Subject: recvmmsg() behaviour with MSG_PEEK flag
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

(sorry in advance - I'm not sure it is the right mailing list for the
question, if it is not, feel free to redirect me)

The behaviour of recvmmsg() with MSG_PEEK flag confuses me. I'd expect
it to peek multiple messages at once, but it seems to peek only the
first one, filling each of the provided struct msghdr with a copy of
the first message. I do not see if it is documented anywhere, is it a
bug or intended design?

What I want to achieve is to first peek into the socket, get the size
of each message, then allocate appropriate buffers and read the
messages with the second recvmmsg() call. This seems to be a
relatively common pattern for reading single messages via recvmsg(),
and I naively expected it to work with recvmmsg() too.

-- 
Regards,
Alexander Babayants.
