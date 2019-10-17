Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78750DA52B
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 07:41:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392684AbfJQFk0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 01:40:26 -0400
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:56565 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731603AbfJQFkZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 01:40:25 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=wenyang@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0TfHZc.W_1571290820;
Received: from IT-C02W23QPG8WN.local(mailfrom:wenyang@linux.alibaba.com fp:SMTPD_---0TfHZc.W_1571290820)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 17 Oct 2019 13:40:21 +0800
From:   Wen Yang <wenyang@linux.alibaba.com>
Subject: Re: [PATCH] net: mscc: ocelot: add missing of_node_put after calling
 of_get_child_by_name
To:     David Miller <davem@davemloft.net>
Cc:     alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        xlpang@linux.alibaba.com, zhiche.yy@alibaba-inc.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190929065424.2437-1-wenyang@linux.alibaba.com>
 <20191001.100233.2002881947003652758.davem@davemloft.net>
Message-ID: <0582802f-2f2e-34d4-8261-78d92646259f@linux.alibaba.com>
Date:   Thu, 17 Oct 2019 13:40:20 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191001.100233.2002881947003652758.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2019/10/2 1:02 上午, David Miller wrote:
> From: Wen Yang <wenyang@linux.alibaba.com>
> Date: Sun, 29 Sep 2019 14:54:24 +0800
> 
>> of_node_put needs to be called when the device node which is got
>> from of_get_child_by_name finished using.
>> In both cases of success and failure, we need to release 'ports',
>> so clean up the code using goto.
>>
>> fixes: a556c76adc05 ("net: mscc: Add initial Ocelot switch support")
>> Signed-off-by: Wen Yang <wenyang@linux.alibaba.com>
> 
> Applied.
> 

Thank you for your comments.

We checked the code repository and found that both ‘Fixes’ and ‘fixes’ 
are being used, such as:

commit a53651ec93a8d7ab5b26c5390e0c389048b4b4b6
…
     net: ena: don't wake up tx queue when down
…
     fixes: 1738cd3ed342 (net: ena: Add a driver for Amazon Elastic 
Network Adapters (ENA))
…

And,

commit 1df379924304b687263942452836db1d725155df
…
     clk: consoldiate the __clk_get_hw() declarations
…

     Fixes: 59fcdce425b7 ("clk: Remove ifdef for COMMON_CLK in 
clk-provider.h")
     fixes: 73e0e496afda ("clkdev: Always allocate a struct clk and call 
__clk_get() w/ CCF")
…


It is also found that the sha1 following ‘Fixes:’ requires at least 12 
digits.

So we plan to modify the checkpatch.pl script to check for these issues.


diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index a85d719..ddcd2d0 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2925,7 +2925,7 @@ sub process {
  		}

  # check for invalid commit id
-		if ($in_commit_log && $line =~ 
/(^fixes:|\bcommit)\s+([0-9a-f]{6,40})\b/i) {
+		if ($in_commit_log && $line =~ /(\bcommit)\s+([0-9a-f]{6,40})\b/i) {
  			my $id;
  			my $description;
  			($id, $description) = git_commit_info($2, undef, undef);
@@ -2935,6 +2935,25 @@ sub process {
  			}
  		}

+# check for fixes tag
+		if ($in_commit_log && $line =~ /(^fixes:)\s+([0-9a-f]{6,40})\b/i) {
+			my $id;
+			my $description;
+			($id, $description) = git_commit_info($2, undef, undef);
+			if (!defined($id)) {
+				WARN("UNKNOWN_COMMIT_ID",
+				     "Unknown commit id '$2', maybe rebased or not pulled?\n" . 
$herecurr);
+			}
+			if ($1 ne "Fixes") {
+				WARN("FIXES_TAG_STYLE",
+				     "The fixes tag should be capitalized (Fixes:).\n" . $hereprev);
+			}
+			if (length($2) < 12) {
+				WARN("FIXES_TAG_STYLE",
+				     "SHA1 should be at least 12 digits long.\n" . $hereprev);
+			}
+		}
+
  # ignore non-hunk lines and lines being removed
  		next if (!$hunk_line || $line =~ /^-/);


--
Best wishes,
Wen Yang



