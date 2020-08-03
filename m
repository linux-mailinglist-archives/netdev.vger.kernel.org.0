Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AF2923ACDF
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 21:21:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727929AbgHCTTc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 15:19:32 -0400
Received: from smtp03.smtpout.orange.fr ([80.12.242.125]:47906 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726847AbgHCTTb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 15:19:31 -0400
Received: from [10.0.2.15] ([92.140.224.28])
        by mwinf5d06 with ME
        id B7KS2300F0dNxE4037KTtX; Mon, 03 Aug 2020 21:19:29 +0200
X-ME-Helo: [10.0.2.15]
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Mon, 03 Aug 2020 21:19:29 +0200
X-ME-IP: 92.140.224.28
Subject: Re: [PATCH] gve: Fix the size used in a 'dma_free_coherent()' call
To:     Jakub Kicinski <kuba@kernel.org>, Joe Perches <joe@perches.com>
Cc:     csully@google.com, sagis@google.com, jonolson@google.com,
        davem@davemloft.net, lrizzo@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <20200802141523.691565-1-christophe.jaillet@wanadoo.fr>
 <20200803084106.050eb7f6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Message-ID: <3a25ddc6-adaa-d17d-50f4-8f8ab2ed25eb@wanadoo.fr>
Date:   Mon, 3 Aug 2020 21:19:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200803084106.050eb7f6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 03/08/2020 à 17:41, Jakub Kicinski a écrit :
> On Sun,  2 Aug 2020 16:15:23 +0200 Christophe JAILLET wrote:
>> Update the size used in 'dma_free_coherent()' in order to match the one
>> used in the corresponding 'dma_alloc_coherent()'.
>>
>> Fixes: 893ce44df5 ("gve: Add basic driver framework for Compute Engine Virtual NIC")
>> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> 
> Fixes tag: Fixes: 893ce44df5 ("gve: Add basic driver framework for Compute Engine Virtual NIC")
> Has these problem(s):
> 	- SHA1 should be at least 12 digits long
> 	  Can be fixed by setting core.abbrev to 12 (or more) or (for git v2.11
> 	  or later) just making sure it is not set (or set to "auto").
> 

Hi,

I have git 2.25.1 and core.abbrev is already 12, both in my global 
.gitconfig and in the specific .git/gitconfig of my repo.

I would have expected checkpatch to catch this kind of small issue.
Unless I do something wrong, it doesn't.

Joe, does it make sense to you and would one of the following patch help?

If I understand the regex correctly, I guess that checkpatch should 
already spot such things. If correct, proposal 1 fix a bug.
If I'm wrong, proposal 2 adds a new test.

CJ



Proposal #1 : find what looks like a commit number, with 5+ char 
(instead of 12+), before looking if it is looks like a standard layout 
with expected length
===========
diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index cc5542cc234f..f42b6a65f5c1 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2828,7 +2828,7 @@ sub process {
                     $line !~ 
/^\s*(?:Link|Patchwork|http|https|BugLink|base-commit):/i &&
                     $line !~ /^This reverts commit [0-9a-f]{7,40}/ &&
                     ($line =~ /\bcommit\s+[0-9a-f]{5,}\b/i ||
-                    ($line =~ /(?:\s|^)[0-9a-f]{12,40}(?:[\s"'\(\[]|$)/i &&
+                    ($line =~ /(?:\s|^)[0-9a-f]{5,40}(?:[\s"'\(\[]|$)/i &&
                       $line !~ /[\<\[][0-9a-f]{12,40}[\>\]]/i &&
                       $line !~ /\bfixes:\s*[0-9a-f]{12,40}/i))) {
                         my $init_char = "c";




Proposal #2 : add a specific and explicit check
===========
diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index cc5542cc234f..13ecfbd38af3 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2989,6 +2989,12 @@ sub process {
                         }
                 }

+# check for too short commit id
+               if ($in_commit_log && $line =~ 
/(^fixes:|\bcommit)\s+([0-9a-f]{0,11})\b/i) {
+                               WARN("TOO_SHORT_COMMIT_ID",
+                                    "\"$1\" tag should be at least 12 
chars long. $2 is only " . length($2) . " long\n" . $herecurr);
+               }
+
  # ignore non-hunk lines and lines being removed
                 next if (!$hunk_line || $line =~ /^-/);

