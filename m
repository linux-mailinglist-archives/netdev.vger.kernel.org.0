Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CE9C27D538
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 19:56:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727893AbgI2R42 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 13:56:28 -0400
Received: from mga11.intel.com ([192.55.52.93]:56872 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725779AbgI2R42 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 13:56:28 -0400
IronPort-SDR: CqmbMguFIt9Ds4Ke0Ro5cH7UV9HIcvOixWRLnuvb45J/+x/qVEZkmqIz/98+W0VsT0D7XOEyP/
 saNG4Qlx7S7A==
X-IronPort-AV: E=McAfee;i="6000,8403,9759"; a="159587724"
X-IronPort-AV: E=Sophos;i="5.77,319,1596524400"; 
   d="scan'208";a="159587724"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2020 10:56:27 -0700
IronPort-SDR: o2TF301Alenk8MvWBXMyTOTI0oFnNzoyn4W5BYZvzmkD3ZjYJOGGPRYgt9dqPd0mf+tV4Ah+0l
 hyXXFj38DOPA==
X-IronPort-AV: E=Sophos;i="5.77,319,1596524400"; 
   d="scan'208";a="492551745"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.209.162.133]) ([10.209.162.133])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2020 10:56:25 -0700
Subject: Re: [RFC iproute2-next] devlink: display elapsed time during flash
 update
To:     Jakub Kicinski <kubakici@wp.pl>
Cc:     netdev@vger.kernel.org, snelson@pensando.io
References: <20200928234945.3417905-1-jacob.e.keller@intel.com>
 <20200929101846.2a296015@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <b4f664d9-301c-1157-0049-50dbea856dda@intel.com>
Date:   Tue, 29 Sep 2020 10:56:23 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20200929101846.2a296015@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/29/2020 10:18 AM, Jakub Kicinski wrote:
> On Mon, 28 Sep 2020 16:49:45 -0700 Jacob Keller wrote:
>> For some devices, updating the flash can take significant time during
>> operations where no status can meaningfully be reported. This can be
>> somewhat confusing to a user who sees devlink appear to hang on the
>> terminal waiting for the device to update.
>>
>> Provide a ticking counter of the time elapsed since the previous status
>> message in order to make it clear that the program is not simply stuck.
>>
>> Do not display this message unless a few seconds have passed since the
>> last status update. Additionally, if the previous status notification
>> included a timeout, display this as part of the message. If we do not
>> receive an error or a new status without that time out, replace it with
>> the text "timeout reached".
>>
>> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
>> ---
>> Sending this as an RFC because I doubt this is the best implementation. For
>> one, I get a weird display issue where the cursor doesn't always end up on
>> the end of line in my shell.. The % display works properly, so I'm not sure
>> what's wrong here.
>>
>> Second, even though select should be timing out every 1/10th of a second for
>> screen updates, I don't seem to get that behavior in my test. It takes about
>> 8 to 10 seconds for the first elapsed time message to be displayed, and it
>> updates really slowly. Is select just not that precise? I even tried using a
>> timeout of zero, but this means we refresh way too often and it looks bad. I
>> am not sure what is wrong here...
> 
> Strange. Did you strace it? Perhaps it's some form of output buffering?
> 

Haven't yet, just noticed the weird output behavior and timing
inconsistency.

>> diff --git a/devlink/devlink.c b/devlink/devlink.c
>> index 0374175eda3d..7fb4b5ef1ebe 100644
>> --- a/devlink/devlink.c
>> +++ b/devlink/devlink.c
>> @@ -33,6 +33,7 @@
>>  #include <sys/select.h>
>>  #include <sys/socket.h>
>>  #include <sys/types.h>
>> +#include <sys/time.h>
>>  #include <rt_names.h>
>>  
>>  #include "version.h"
>> @@ -3066,6 +3067,9 @@ static int cmd_dev_info(struct dl *dl)
>>  
>>  struct cmd_dev_flash_status_ctx {
>>  	struct dl *dl;
>> +	struct timeval last_status_msg;
>> +	char timeout_msg[128];
> 
> Really you just need the length (as returned by snprintf), right?

Hmm, yea probably don't need the full message.
> 
>> +	uint64_t timeout;
>>  	char *last_msg;
>>  	char *last_component;
>>  	uint8_t not_first:1,
>> @@ -3083,6 +3087,14 @@ static int nullstrcmp(const char *str1, const char *str2)
>>  	return str1 ? 1 : -1;
>>  }
>>  
>> +static void cmd_dev_flash_clear_elapsed_time(struct cmd_dev_flash_status_ctx *ctx)
>> +{
>> +	int i;
>> +
>> +	for (i = 0; i < strlen(ctx->timeout_msg); i++)
>> +		pr_out_tty("\b");
> 
> I wonder if it's not easier to \r, I guess the existing code likes \b
> so be it.
> 

If we '\r', we'd have to re-write the whole line, right? Hmm.

I'm also thinking that perhaps part of the display issue is that these
"\b" outputs aren't being sent as one unit so some sort of buffering
results in the inconsistent display. Note, the text does fully display
properly, it just doesn't seem to update the cursor location correctly,
resulting in the cursor position bouncing around rapidly and being very
distracting.

>> +}
>> +
>>  static int cmd_dev_flash_status_cb(const struct nlmsghdr *nlh, void *data)
>>  {
>>  	struct cmd_dev_flash_status_ctx *ctx = data;
> 
>> +static void cmd_dev_flash_time_elapsed(struct cmd_dev_flash_status_ctx *ctx)
>> +{
>> +	struct timeval now, res;
>> +
>> +	gettimeofday(&now, NULL);
>> +	timersub(&now, &ctx->last_status_msg, &res);
>> +
>> +	/* Don't start displaying a timeout message until we've elapsed a few
>> +	 * seconds...
>> +	 */
>> +	if (res.tv_sec > 3) {
>> +		uint elapsed_m, elapsed_s;
> 
> This may be the first uint use in iproute2..

>> +		/* clear the last elapsed time message, if we have one */
>> +		cmd_dev_flash_clear_elapsed_time(ctx);
>> +
>> +		elapsed_m = res.tv_sec / 60;
>> +		elapsed_s = res.tv_sec % 60;
