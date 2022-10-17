Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9AD160110A
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 16:23:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230345AbiJQOXX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 10:23:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230368AbiJQOXU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 10:23:20 -0400
Received: from fanzine2.igalia.com (fanzine.igalia.com [178.60.130.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45A5E65655;
        Mon, 17 Oct 2022 07:23:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
        s=20170329; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=9xfL6/k7u4koaszP9KMyOY8wVCMBnHlZFYRYE37DwZY=; b=o281kDXC1NHE1O1sCc6sXM9LPE
        mLG85YE4HpDt2UDR1cx42oNsH8/nYPAlzUVkWE51DdULUUsrQhU39HNcA/p+K+w576wxw35/ljBCA
        oAJ5D+M2I6R1f0OeoZFz1dc/37unXROytiAdKajzm9uTEpMvan310AjwwrKiCLsisNyaiX/JKFC0T
        O7J4aiHOU+KPie0YpoMEzCG1excULa3xLark3GU9tNNF7PBwRs4w4WjVHhJRczPkDFbOngJVd2Cva
        FhHI1pO3mpjqcXkn6Xt/aoyELWmIiKVa0sntcXfg1c92No4PQRjZBQH4GSPR52zDjWtBPw2dsx5mC
        yL6oJufQ==;
Received: from [179.113.159.85] (helo=[192.168.1.60])
        by fanzine2.igalia.com with esmtpsa 
        (Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128) (Exim)
        id 1okR18-000PGI-VK; Mon, 17 Oct 2022 16:22:58 +0200
Message-ID: <5178691f-3a43-9f19-dcd0-98d3a104afa3@igalia.com>
Date:   Mon, 17 Oct 2022 11:22:35 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.2
Subject: Re: [PATCH V3 04/11] um: Improve panic notifiers consistency and
 ordering
Content-Language: en-US
To:     Richard Weinberger <richard@nod.at>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        linux-um <linux-um@lists.infradead.org>,
        kexec <kexec@lists.infradead.org>, bhe <bhe@redhat.com>,
        Petr Mladek <pmladek@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-hyperv <linux-hyperv@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, x86 <x86@kernel.org>,
        kernel-dev <kernel-dev@igalia.com>, kernel <kernel@gpiccoli.net>,
        halves <halves@canonical.com>,
        fabiomirmar <fabiomirmar@gmail.com>,
        alejandro j jimenez <alejandro.j.jimenez@oracle.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Arnd Bergmann <arnd@arndb.de>, bp <bp@alien8.de>,
        Jonathan Corbet <corbet@lwn.net>,
        d hatayama <d.hatayama@jp.fujitsu.com>,
        dave hansen <dave.hansen@linux.intel.com>,
        dyoung <dyoung@redhat.com>, feng tang <feng.tang@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        mikelley <mikelley@microsoft.com>,
        hidehiro kawai ez <hidehiro.kawai.ez@hitachi.com>,
        jgross <jgross@suse.com>,
        John Ogness <john.ogness@linutronix.de>,
        Kees Cook <keescook@chromium.org>,
        Andy Lutomirski <luto@kernel.org>,
        mhiramat <mhiramat@kernel.org>, mingo <mingo@redhat.com>,
        paulmck <paulmck@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        senozhatsky <senozhatsky@chromium.org>,
        stern <stern@rowland.harvard.edu>, tglx <tglx@linutronix.de>,
        vgoyal <vgoyal@redhat.com>, vkuznets <vkuznets@redhat.com>,
        will <will@kernel.org>, xuqiang36 <xuqiang36@huawei.com>,
        anton ivanov <anton.ivanov@cambridgegreys.com>
References: <20220819221731.480795-1-gpiccoli@igalia.com>
 <20220819221731.480795-5-gpiccoli@igalia.com>
 <1f464f3d-6668-9e05-bcb7-1b419b5373e1@igalia.com>
 <2087154222.237106.1663535981252.JavaMail.zimbra@nod.at>
 <280ce0ae-5a50-626f-930f-2661a109fa36@igalia.com>
 <422015181.40644.1666015829599.JavaMail.zimbra@nod.at>
From:   "Guilherme G. Piccoli" <gpiccoli@igalia.com>
In-Reply-To: <422015181.40644.1666015829599.JavaMail.zimbra@nod.at>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17/10/2022 11:10, Richard Weinberger wrote:
> ----- Ursprüngliche Mail -----
>> Von: "Guilherme G. Piccoli" <gpiccoli@igalia.com>
>> Hi Richard / Johannes, is there any news on this one?
>> Thanks in advance,
> 
> It's upstream:
> git.kernel.org/linus/758dfdb9185cf94160f20e85bbe05583e3cd4ff4
> 
> Thanks,
> //richard

Wow, thanks! I am sorry, I didn't notice.
Cheers,


Guilherme
