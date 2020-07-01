Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC651210C2B
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 15:26:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731069AbgGAN0H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 09:26:07 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:53713 "EHLO
        www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729429AbgGAN0E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 09:26:04 -0400
Received: from fsav109.sakura.ne.jp (fsav109.sakura.ne.jp [27.133.134.236])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 061DOXC9036582;
        Wed, 1 Jul 2020 22:24:33 +0900 (JST)
        (envelope-from penguin-kernel@i-love.sakura.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav109.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav109.sakura.ne.jp);
 Wed, 01 Jul 2020 22:24:33 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav109.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 061DOW2e036570
        (version=TLSv1.2 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO);
        Wed, 1 Jul 2020 22:24:32 +0900 (JST)
        (envelope-from penguin-kernel@i-love.sakura.ne.jp)
Subject: Re: linux-next: umh: fix processed error when UMH_WAIT_PROC is used
 seems to break linux bridge on s390x (bisected)
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Luis Chamberlain <mcgrof@kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>, ast@kernel.org,
        axboe@kernel.dk, bfields@fieldses.org,
        bridge@lists.linux-foundation.org, chainsaw@gentoo.org,
        christian.brauner@ubuntu.com, chuck.lever@oracle.com,
        davem@davemloft.net, dhowells@redhat.com,
        gregkh@linuxfoundation.org, jarkko.sakkinen@linux.intel.com,
        jmorris@namei.org, josh@joshtriplett.org, keescook@chromium.org,
        keyrings@vger.kernel.org, kuba@kernel.org,
        lars.ellenberg@linbit.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-security-module@vger.kernel.org, nikolay@cumulusnetworks.com,
        philipp.reisner@linbit.com, ravenexp@gmail.com,
        roopa@cumulusnetworks.com, serge@hallyn.com, slyfox@gentoo.org,
        viro@zeniv.linux.org.uk, yangtiezhu@loongson.cn,
        netdev@vger.kernel.org, markward@linux.ibm.com,
        linux-s390 <linux-s390@vger.kernel.org>
References: <b7d658b9-606a-feb1-61f9-b58e3420d711@de.ibm.com>
 <3118dc0d-a3af-9337-c897-2380062a8644@de.ibm.com>
 <20200624144311.GA5839@infradead.org>
 <9e767819-9bbe-2181-521e-4d8ca28ca4f7@de.ibm.com>
 <20200624160953.GH4332@42.do-not-panic.com>
 <ea41e2a9-61f7-aec1-79e5-7b08b6dd5119@de.ibm.com>
 <4e27098e-ac8d-98f0-3a9a-ea25242e24ec@de.ibm.com>
 <4d8fbcea-a892-3453-091f-d57c03f9aa90@de.ibm.com>
 <1263e370-7cee-24d8-b98c-117bf7c90a83@de.ibm.com>
 <20200626025410.GJ4332@42.do-not-panic.com>
 <20200630175704.GO13911@42.do-not-panic.com>
 <b24d8dae-1872-ba2c-acd4-ed46c0781317@de.ibm.com>
From:   Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Message-ID: <a6792135-3285-0861-014e-3db85ea251dc@i-love.sakura.ne.jp>
Date:   Wed, 1 Jul 2020 22:24:29 +0900
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <b24d8dae-1872-ba2c-acd4-ed46c0781317@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/07/01 19:08, Christian Borntraeger wrote:
> 
> 
> On 30.06.20 19:57, Luis Chamberlain wrote:
>> On Fri, Jun 26, 2020 at 02:54:10AM +0000, Luis Chamberlain wrote:
>>> On Wed, Jun 24, 2020 at 08:37:55PM +0200, Christian Borntraeger wrote:
>>>>
>>>>
>>>> On 24.06.20 20:32, Christian Borntraeger wrote:
>>>> [...]> 
>>>>> So the translations look correct. But your change is actually a sematic change
>>>>> if(ret) will only trigger if there is an error
>>>>> if (KWIFEXITED(ret)) will always trigger when the process ends. So we will always overwrite -ECHILD
>>>>> and we did not do it before. 
>>>>>
>>>>
>>>> So the right fix is
>>>>
>>>> diff --git a/kernel/umh.c b/kernel/umh.c
>>>> index f81e8698e36e..a3a3196e84d1 100644
>>>> --- a/kernel/umh.c
>>>> +++ b/kernel/umh.c
>>>> @@ -154,7 +154,7 @@ static void call_usermodehelper_exec_sync(struct subprocess_info *sub_info)
>>>>                  * the real error code is already in sub_info->retval or
>>>>                  * sub_info->retval is 0 anyway, so don't mess with it then.
>>>>                  */
>>>> -               if (KWIFEXITED(ret))
>>>> +               if (KWEXITSTATUS(ret))
>>>>                         sub_info->retval = KWEXITSTATUS(ret);

Well, it is not br_stp_call_user() but br_stp_start() which is expecting
to set sub_info->retval for both KWIFEXITED() case and KWIFSIGNALED() case.
That is, sub_info->retval needs to carry raw value (i.e. without "umh: fix
processed error when UMH_WAIT_PROC is used" will be the correct behavior).

