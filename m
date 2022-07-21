Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F5DF57CCB2
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 15:51:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230462AbiGUNvg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 09:51:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230168AbiGUNvU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 09:51:20 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66F7827CD6;
        Thu, 21 Jul 2022 06:51:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1658411171;
        bh=QtbE3oMbR4Z0fnHisQtcK0R0D/j1pPtQnSsUmsDf4O8=;
        h=X-UI-Sender-Class:Date:Subject:To:Cc:References:From:In-Reply-To;
        b=Ytcw0Z/xL9TPZj+kGCndhevFWR7Ky7APlZAQFIcGjboI1cx2UyN9wc5aLFCSSs7ty
         26C5mPuAhDoEOe9NDxrN0XSfsMmeb3mO2nomo4hiw4NM0dI1+C27CjHxRJF7vE2pNL
         FuF6I1O1HAeGVP+ZQMllX4LMQ44ke3wbBwnWQlT8=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.20.60] ([92.116.130.88]) by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1Mof5H-1nhOfq1j4L-00p7fJ; Thu, 21
 Jul 2022 15:46:11 +0200
Message-ID: <7e5dce87-31c1-401f-324a-2aacb6996625@gmx.de>
Date:   Thu, 21 Jul 2022 15:45:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v2 07/13] parisc: Replace regular spinlock with
 spin_trylock on panic path
Content-Language: en-US
To:     "Guilherme G. Piccoli" <gpiccoli@igalia.com>,
        Jeroen Roovers <jer@xs4all.nl>
Cc:     akpm@linux-foundation.org, bhe@redhat.com, pmladek@suse.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        x86@kernel.org, kernel-dev@igalia.com, kernel@gpiccoli.net,
        halves@canonical.com, fabiomirmar@gmail.com,
        alejandro.j.jimenez@oracle.com, andriy.shevchenko@linux.intel.com,
        arnd@arndb.de, bp@alien8.de, corbet@lwn.net,
        d.hatayama@jp.fujitsu.com, dave.hansen@linux.intel.com,
        dyoung@redhat.com, feng.tang@intel.com, gregkh@linuxfoundation.org,
        mikelley@microsoft.com, hidehiro.kawai.ez@hitachi.com,
        jgross@suse.com, john.ogness@linutronix.de, keescook@chromium.org,
        luto@kernel.org, mhiramat@kernel.org, mingo@redhat.com,
        paulmck@kernel.org, peterz@infradead.org, rostedt@goodmis.org,
        senozhatsky@chromium.org, stern@rowland.harvard.edu,
        tglx@linutronix.de, vgoyal@redhat.com, vkuznets@redhat.com,
        will@kernel.org, linux-parisc@vger.kernel.org,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20220719195325.402745-1-gpiccoli@igalia.com>
 <20220719195325.402745-8-gpiccoli@igalia.com>
 <20220720034300.6d2905b8@wim.jer>
 <76b6f764-23a9-ed0b-df3d-b9194c4acc1d@igalia.com>
From:   Helge Deller <deller@gmx.de>
In-Reply-To: <76b6f764-23a9-ed0b-df3d-b9194c4acc1d@igalia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:A2ch0UzKhT2GN3X+8Rl1GQqDJfC/xtKlIw5ATFSiiGdALjoZeLD
 cpq9OM/zovAiIqRw/z1R+GbYN+JEzG9I4ro5GW/OIWKpNEMrIysqUIdBN8k2TDjO5nrIEsP
 BFTW/G/1em9u4Pyk1+Bj9LtVoMH6vp9QwEEsrGJtyJdTnoI2Llbh2h7fVSuDCFgnqXsScgF
 bkLVVvs1ULUD59p94qCdw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:UY2rjKtKFdU=:zzQFKWEd2HyBIE9TID5YgU
 yfesTqt7NvGQbl4KsVNmCfYGEgGhWvNtyHYfn3xlomX5B2zG8XSY7uS+54lUq2uPRSEy9/oHJ
 qscEN77zlLdM3O0cpbxhxu139J4lFdxyiirTrGE5xOI/Svm+JvEAjkt1NzYibywdnXunjgsTB
 BeHl9vmucoz4qc3CK+xgQo+C2jWsxim0Nf7Ds67e8GksrCb6SNt869fg2nxg7vARlYal6cQFz
 CaZcM6gMb2rEYF9wtYOIOZ6LXabvp0oGIgBvECaqLtInhYdCBQRQtRnEXnA85Ba+jPOnfGLA9
 7CW2ldKbApfvDLztSIvgx3EoXjZjGMsJjYPqUmdAXe2tJyd7iNOVeFKfUzlA2hiSzR2q20lkn
 ulF2/7FVm/tyNA8OXlyC6gigOA3lslABqPYmXxV9reUtwtzJ0s5CSnirubJkdO2io9RZA74k5
 eVv9O7HGdFkWnGJhoCidSvJsoeWiLpMdJ1L1VfSFhqCFx7s2Ydd4g0ZMlUg+yXTrfpEcg730b
 5Af+Dn9vC7GxIAJgOZ24udoy4JKjp7V6ti2hCgL5krFzXW5HYFqtF08OsWW7/ivjHI6Tozz9H
 7GmOUbslRFE4oDW6uAI1pq+eE8uKqzeqMpsy9EfhVBPeNpzbwAcNgIrwe3wiuztUekhTQCGx0
 00775x+ngK4H+qHKwuWpQnIj7Z3+ESnX9bBj49u6LYmD6iRGzgmT1frOy0nSKxG98UF/G7tAU
 42s4KxJ33BkTAmXvjKI0FlKDG5XoywFHQzfOyqK0IADro/3VDgDBZJiPDOesO93Mfdh7pXfaQ
 fNVIurfahRkljwXZ0OwNesf8f5Bxq3XxlnOLWKIGtV1lRcoUu2L7boIwt/VRqLCF2sKng99BW
 2HpssJFqOgi9LYxJhTe6Ik+VREyiyhyiWKAlf+IxNzovV4esGfV5TSp5pv4lme1lVcEGFHoY3
 +9j3B05xK/vyzKJ85r9Xff2f7lPT97l6N/+IUMudLCRQvURhsJ30WQ/0Hh/NGCS7iyXEPIrpD
 libJ+S1I8L5x/RJT2foeRGYS8og5LADsLmFqIai2e3LR9PTgjr+q6o0YpgT9NRb2/uauxXjgU
 pOkV/ZXxlFN5iVojqS1wec1g/0n0r53hlLtCnyEYduPUyCo9/EvoyutZQ==
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/21/22 15:19, Guilherme G. Piccoli wrote:
> On 19/07/2022 22:43, Jeroen Roovers wrote:
>>      Hi Guilherme,
>> [...]
>>> + *
>>> + * The _panic version relies in spin_trylock to prevent deadlock
>>> + * on panic path.
>>
>> in =3D> on
>
> Hi Jer, thanks for the suggestion!
>
> Helge, do you think you could fix it when applying, if there's no other
> issue in the patch?
> Thanks,

Guilherme, I'd really prefer that you push the whole series at once throug=
h
some generic tree.

Helge
