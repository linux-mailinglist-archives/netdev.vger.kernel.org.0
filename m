Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FA842130AF
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 02:54:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726615AbgGCAyG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 20:54:06 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:58398 "EHLO
        www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726028AbgGCAyG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 20:54:06 -0400
Received: from fsav303.sakura.ne.jp (fsav303.sakura.ne.jp [153.120.85.134])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 0630q3Dc066718;
        Fri, 3 Jul 2020 09:52:03 +0900 (JST)
        (envelope-from penguin-kernel@i-love.sakura.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav303.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav303.sakura.ne.jp);
 Fri, 03 Jul 2020 09:52:03 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav303.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 0630q2Yw066713
        (version=TLSv1.2 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO);
        Fri, 3 Jul 2020 09:52:02 +0900 (JST)
        (envelope-from penguin-kernel@i-love.sakura.ne.jp)
Subject: Re: linux-next: umh: fix processed error when UMH_WAIT_PROC is used
 seems to break linux bridge on s390x (bisected)
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     David Howells <dhowells@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Christoph Hellwig <hch@infradead.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>, ast@kernel.org,
        axboe@kernel.dk, bfields@fieldses.org,
        bridge@lists.linux-foundation.org, chainsaw@gentoo.org,
        christian.brauner@ubuntu.com, chuck.lever@oracle.com,
        davem@davemloft.net, gregkh@linuxfoundation.org,
        jarkko.sakkinen@linux.intel.com, jmorris@namei.org,
        josh@joshtriplett.org, keescook@chromium.org,
        keyrings@vger.kernel.org, kuba@kernel.org,
        lars.ellenberg@linbit.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-security-module@vger.kernel.org, nikolay@cumulusnetworks.com,
        philipp.reisner@linbit.com, ravenexp@gmail.com,
        roopa@cumulusnetworks.com, serge@hallyn.com, slyfox@gentoo.org,
        viro@zeniv.linux.org.uk, yangtiezhu@loongson.cn,
        netdev@vger.kernel.org, markward@linux.ibm.com,
        linux-s390 <linux-s390@vger.kernel.org>
References: <4d8fbcea-a892-3453-091f-d57c03f9aa90@de.ibm.com>
 <1263e370-7cee-24d8-b98c-117bf7c90a83@de.ibm.com>
 <20200626025410.GJ4332@42.do-not-panic.com>
 <20200630175704.GO13911@42.do-not-panic.com>
 <b24d8dae-1872-ba2c-acd4-ed46c0781317@de.ibm.com>
 <a6792135-3285-0861-014e-3db85ea251dc@i-love.sakura.ne.jp>
 <20200701135324.GS4332@42.do-not-panic.com>
 <8d714a23-bac4-7631-e5fc-f97c20a46083@i-love.sakura.ne.jp>
 <20200701153859.GT4332@42.do-not-panic.com>
 <e3f3e501-2cb7-b683-4b85-2002b7603244@i-love.sakura.ne.jp>
 <20200702194656.GV4332@42.do-not-panic.com>
From:   Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Message-ID: <d8a74a06-de97-54ae-de03-0d955e82f62b@i-love.sakura.ne.jp>
Date:   Fri, 3 Jul 2020 09:52:01 +0900
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200702194656.GV4332@42.do-not-panic.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/07/03 4:46, Luis Chamberlain wrote:
> On Thu, Jul 02, 2020 at 01:26:53PM +0900, Tetsuo Handa wrote:
>> On 2020/07/02 0:38, Luis Chamberlain wrote:
>>> @@ -156,6 +156,18 @@ static void call_usermodehelper_exec_sync(struct subprocess_info *sub_info)
>>>  		 */
>>>  		if (KWIFEXITED(ret))
>>>  			sub_info->retval = KWEXITSTATUS(ret);
>>> +		/*
>>> +		 * Do we really want to be passing the signal, or do we pass
>>> +		 * a single error code for all cases?
>>> +		 */
>>> +		else if (KWIFSIGNALED(ret))
>>> +			sub_info->retval = KWTERMSIG(ret);
>>
>> No, this is bad. Caller of usermode helper is unable to distinguish exit(9)
>> and e.g. SIGKILL'ed by the OOM-killer.
> 
> Right, the question is: do we care?

Yes, we have to care.

> And the umh patch "umh: fix processed error when UMH_WAIT_PROC is used"
> changed this to:
> 
> -       if (ret >= 0) {
> +       if (ret != 0) {
> 
> Prior to the patch negative return values from userspace were still
> being captured, and likewise signals, but the error value was not
> raw, not the actual value. After the patch, since we check for ret != 0
> we still upkeep the sanity check for any error, correct the error value,
> but as you noted signals were ignored as I made the wrong assumption
> we would ignore them. The umh sub_info->retval is set after my original
> patch only if KWIFSIGNALED(ret)), and ignored signals, and so that
> would be now capitured with the additional KWIFSIGNALED(ret)) check.

"call_usermodehelper_keys() == 0" (i.e. usermode helper was successfully
started and successfully terminated via exit(0)) is different from "there is
nothing to do". call_sbin_request_key() == 0 case still has to check for
possibility of -ENOKEY case.

> 
> The question still stands:
> 
> Do we want to open code all these checks or simply wrap them up in
> the umh. If we do the later, as you note exit(9) and a SIGKILL will
> be the same to the inspector in the kernel. But do we care?

Yes, we do care.

> 
> Do we really want umh callers differntiatin between signals and exit values?

Yes, we do.

> 
> The alternative to making a compromise is using generic wrappers for
> things which make sense and letting the callers use those.

I suggest just introducing KWIFEXITED()/KWEXITSTATUS()/KWIFSIGNALED()/KWTERMSIG()
macros and fixing the callers, for some callers are not aware of possibility of
KWIFSIGNALED() case.

For example, conn_try_outdate_peer() in drivers/block/drbd/drbd_nl.c misbehaves if
drbd_usermode_helper process was terminated by a signal, for the switch() statement
after returning from conn_helper() is assuming that the return value of conn_helper()
is a KWEXITSTATUS() value if drbd_usermode_helper process was successfully started.
If drbd_usermode_helper process was terminated by SIGQUIT (which is 3),
conn_try_outdate_peer() will by error hit "case P_INCONSISTENT:" (which is 3);
conn_try_outdate_peer() should hit "default: /* The script is broken ... */"
unless KWIFEXITED() == true.

Your patch is trying to obnubilate the return code.

