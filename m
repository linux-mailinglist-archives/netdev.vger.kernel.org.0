Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A0BEB3AEE
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 15:05:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732986AbfIPNE5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 09:04:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37699 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732960AbfIPNE4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Sep 2019 09:04:56 -0400
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com [209.85.208.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D73C3796ED
        for <netdev@vger.kernel.org>; Mon, 16 Sep 2019 13:04:55 +0000 (UTC)
Received: by mail-ed1-f72.google.com with SMTP id y66so22426860ede.16
        for <netdev@vger.kernel.org>; Mon, 16 Sep 2019 06:04:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=EsU047fiTiS7etZNBhtXyxLIzV+u5+6Umol5GabBksY=;
        b=afAzyujIIJoAxi1hOJGL3zZaq2KUVXxP11IS8WV0su2vzxaay/1duzcbuDjbspC7+g
         OFliMFb4ZlTf8/Y0QMi8bt3q6n0b5VfpaIItEaQX69HYT9KZfJMIB1C6oRu0GRgJu5WJ
         zuUvY4/divxVuxPCSk1xvK2oCjh76czUQRvDmgW77mFh5ZbrU5nyHVSesCTAjiAoUMlJ
         SuTMqoS5gGWy42becy6PL4d5zV5o4fQhcngPJtWs/fwoO4GSWgHVgwY5oNKE2p6strim
         Ga72ktCYu58vBiEGyu0K8aVb9nF9oiJZ5ByvCAXLpu0lLKNZJQCbOhlMBaEWDjnzzGc3
         CWYw==
X-Gm-Message-State: APjAAAXduEqiX7igKe+5UkBjWT58qqF4vZMO4Ohcwc6qRi9XRjBCvCji
        2UwpgVlS6yC1pj+0mD1yhVB+6bFjQhzvm5pKLLef9D+SSY1dh1wSmZA97yCaQNWb/KAS9BfPQmF
        +U0DuRp8PnI7KobDV
X-Received: by 2002:a05:6402:13cd:: with SMTP id a13mr11561250edx.6.1568639094008;
        Mon, 16 Sep 2019 06:04:54 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwG/Bx8GuDXctx0TmhTxLUml8kAhLyqs5D05yZJXMpRxS2q8tqAArLdT6E2V2YG9960X+DetQ==
X-Received: by 2002:a05:6402:13cd:: with SMTP id a13mr11561234edx.6.1568639093850;
        Mon, 16 Sep 2019 06:04:53 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id k8sm2404323ejg.22.2019.09.16.06.04.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Sep 2019 06:04:51 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id EF761180641; Mon, 16 Sep 2019 14:52:45 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>,
        "Daniel T. Lee" <danieltimlee@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        brouer@redhat.com
Subject: Re: [v3 2/3] samples: pktgen: add helper functions for IP(v4/v6) CIDR parsing
In-Reply-To: <20190916085317.02e4d985@carbon>
References: <20190914151353.18054-1-danieltimlee@gmail.com> <20190914151353.18054-2-danieltimlee@gmail.com> <20190916085317.02e4d985@carbon>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 16 Sep 2019 14:52:45 +0200
Message-ID: <87sgowl7xe.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jesper Dangaard Brouer <brouer@redhat.com> writes:

> On Sun, 15 Sep 2019 00:13:52 +0900
> "Daniel T. Lee" <danieltimlee@gmail.com> wrote:
>
>> This commit adds CIDR parsing and IP validate helper function to parse
>> single IP or range of IP with CIDR. (e.g. 198.18.0.0/15)
>> 
>> Helpers will be used in prior to set target address in samples/pktgen.
>> 
>> Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
>> ---
>> Changes since v3:
>>  * Set errexit option to stop script execution on error
>> 
>>  samples/pktgen/functions.sh | 124 ++++++++++++++++++++++++++++++++++++
>>  1 file changed, 124 insertions(+)
>> 
>> diff --git a/samples/pktgen/functions.sh b/samples/pktgen/functions.sh
>> index 4af4046d71be..87ae61701904 100644
>> --- a/samples/pktgen/functions.sh
>> +++ b/samples/pktgen/functions.sh
>> @@ -5,6 +5,8 @@
>>  # Author: Jesper Dangaaard Brouer
>>  # License: GPL
>>  
>> +set -o errexit
>
> Unfortunately, this breaks the scripts.
>
> The function proc_cmd are designed to grep after "Result: OK:" which
> might fail, and your patch/change makes the script stop immediately.
> We actually want to continue, and output what command that failed (and
> also grep again after "Result:" to provide the kernel reason).
>
> Even if you somehow "fix" function proc_cmd, then we in general want to
> catch different error situations by looking at status $?, and output
> meaning full errors via calling err() function.

Yeah, I can see that some functions do this, but I don't think that
would be too hard to fix. See sample diff below (will need some more
work to deal with grep failing, but you get the idea).

I'd argue that fixing this is the right thing to do... Maybe add set -o
nounset as well while we're at it? :)

> IHMO as minimum with errexit you need a 'trap' function that can
> help/inform the user of what went wrong.

Yeah, trap ERR (which would also need set -o errtrace to work inside the
functions) might be useful in any case.

-Toke




diff --git a/samples/pktgen/functions.sh b/samples/pktgen/functions.sh
index 4af4046d71be..d61a348f85f5 100644
--- a/samples/pktgen/functions.sh
+++ b/samples/pktgen/functions.sh
@@ -58,6 +58,7 @@ function pg_set() {
 function proc_cmd() {
     local result
     local proc_file=$1
+    local status=0
     # after shift, the remaining args are contained in $@
     shift
     local proc_ctrl=${PROC_DIR}/$proc_file
@@ -73,8 +74,7 @@ function proc_cmd() {
        echo "cmd: $@ > $proc_ctrl"
     fi
     # Quoting of "$@" is important for space expansion
-    echo "$@" > "$proc_ctrl"
-    local status=$?
+    echo "$@" > "$proc_ctrl" || status=$?
 
     result=$(grep "Result: OK:" $proc_ctrl)
     # Due to pgctrl, cannot use exit code $? from grep
