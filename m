Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3522327D60A
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 20:45:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728367AbgI2Sph (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 14:45:37 -0400
Received: from mga17.intel.com ([192.55.52.151]:21575 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728166AbgI2Sph (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 14:45:37 -0400
IronPort-SDR: v9GmUy4+qMxqpCA3qJwgKNOcLOEkQ//o8NGsycQy3fcorDG4FC3YVbHGzae8XrEkhACnoQ+Jam
 2PHgciPkMxMQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9759"; a="142278952"
X-IronPort-AV: E=Sophos;i="5.77,319,1596524400"; 
   d="scan'208";a="142278952"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2020 11:45:36 -0700
IronPort-SDR: gmpE1OnAtY8G+ewgLZbNvfC62ErKubdfwOP2r/wvp3CbOj/e3Ex5na17HWJStMujhJb14XCXQg
 aaaT2eKGg+zw==
X-IronPort-AV: E=Sophos;i="5.77,319,1596524400"; 
   d="scan'208";a="492864035"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.209.162.133]) ([10.209.162.133])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2020 11:45:36 -0700
Subject: Re: [RFC iproute2-next] devlink: display elapsed time during flash
 update
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Jakub Kicinski <kubakici@wp.pl>, netdev@vger.kernel.org,
        snelson@pensando.io
References: <20200928234945.3417905-1-jacob.e.keller@intel.com>
 <20200929101846.2a296015@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <b4f664d9-301c-1157-0049-50dbea856dda@intel.com>
 <20200929180722.GA1674045@shredder>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <4baf15d7-3e7a-9cf3-16cc-93507d07cf5b@intel.com>
Date:   Tue, 29 Sep 2020 11:45:33 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20200929180722.GA1674045@shredder>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/29/2020 11:07 AM, Ido Schimmel wrote:
> On Tue, Sep 29, 2020 at 10:56:23AM -0700, Jacob Keller wrote:
>>
>>
>> On 9/29/2020 10:18 AM, Jakub Kicinski wrote:
>>> On Mon, 28 Sep 2020 16:49:45 -0700 Jacob Keller wrote:
>>>> For some devices, updating the flash can take significant time during
>>>> operations where no status can meaningfully be reported. This can be
>>>> somewhat confusing to a user who sees devlink appear to hang on the
>>>> terminal waiting for the device to update.
>>>>
>>>> Provide a ticking counter of the time elapsed since the previous status
>>>> message in order to make it clear that the program is not simply stuck.
>>>>
>>>> Do not display this message unless a few seconds have passed since the
>>>> last status update. Additionally, if the previous status notification
>>>> included a timeout, display this as part of the message. If we do not
>>>> receive an error or a new status without that time out, replace it with
>>>> the text "timeout reached".
>>>>
>>>> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
>>>> ---
>>>> Sending this as an RFC because I doubt this is the best implementation. For
>>>> one, I get a weird display issue where the cursor doesn't always end up on
>>>> the end of line in my shell.. The % display works properly, so I'm not sure
>>>> what's wrong here.
>>>>
>>>> Second, even though select should be timing out every 1/10th of a second for
>>>> screen updates, I don't seem to get that behavior in my test. It takes about
>>>> 8 to 10 seconds for the first elapsed time message to be displayed, and it
>>>> updates really slowly. Is select just not that precise? I even tried using a
>>>> timeout of zero, but this means we refresh way too often and it looks bad. I
>>>> am not sure what is wrong here...
>>>
>>> Strange. Did you strace it? Perhaps it's some form of output buffering?
>>>
>>
>> Haven't yet, just noticed the weird output behavior and timing
>> inconsistency.
> 
> Might be similar to this:
> https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=8e6bce735a132150c23503a55ea0aef55a01425f
> 

Yep, I needed the fflush! That resolved the display issue!

Thanks,
Jake
