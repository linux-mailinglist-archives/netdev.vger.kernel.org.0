Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F18E655C9AC
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 14:57:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242518AbiF0WPi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 18:15:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242517AbiF0WPh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 18:15:37 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AB876301;
        Mon, 27 Jun 2022 15:15:34 -0700 (PDT)
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1o5x0u-000Aqo-0L; Tue, 28 Jun 2022 00:15:24 +0200
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1o5x0t-0003wD-HY; Tue, 28 Jun 2022 00:15:23 +0200
Subject: Re: [PATCH 0/2] Introduce security_create_user_ns()
To:     Paul Moore <paul@paul-moore.com>,
        Christian Brauner <brauner@kernel.org>
Cc:     Frederick Lawler <fred@cloudflare.com>,
        Casey Schaufler <casey@schaufler-ca.com>, kpsingh@kernel.org,
        revest@chromium.org, jackmanb@chromium.org, ast@kernel.org,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, jmorris@namei.org, serge@hallyn.com,
        bpf@vger.kernel.org, linux-security-module@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-team@cloudflare.com
References: <20220621233939.993579-1-fred@cloudflare.com>
 <ce1653b1-feb0-1a99-0e97-8dfb289eeb79@schaufler-ca.com>
 <b72c889a-4a50-3330-baae-3bbf065e7187@cloudflare.com>
 <CAHC9VhSTkEMT90Tk+=iTyp3npWEm+3imrkFVX2qb=XsOPp9F=A@mail.gmail.com>
 <20220627121137.cnmctlxxtcgzwrws@wittgenstein>
 <CAHC9VhSQH9tE-NgU6Q-GLqSy7R6FVjSbp4Tc4gVTbjZCqAWy5Q@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <6a8fba0a-c9c9-61ba-793a-c2e0c2924f88@iogearbox.net>
Date:   Tue, 28 Jun 2022 00:15:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAHC9VhSQH9tE-NgU6Q-GLqSy7R6FVjSbp4Tc4gVTbjZCqAWy5Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.6/26586/Mon Jun 27 10:06:41 2022)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/27/22 11:56 PM, Paul Moore wrote:
> On Mon, Jun 27, 2022 at 8:11 AM Christian Brauner <brauner@kernel.org> wrote:
>> On Thu, Jun 23, 2022 at 11:21:37PM -0400, Paul Moore wrote:
> 
> ...
> 
>>> This is one of the reasons why I usually like to see at least one LSM
>>> implementation to go along with every new/modified hook.  The
>>> implementation forces you to think about what information is necessary
>>> to perform a basic access control decision; sometimes it isn't always
>>> obvious until you have to write the access control :)
>>
>> I spoke to Frederick at length during LSS and as I've been given to
>> understand there's a eBPF program that would immediately use this new
>> hook. Now I don't want to get into the whole "Is the eBPF LSM hook
>> infrastructure an LSM" but I think we can let this count as a legitimate
>> first user of this hook/code.
> 
> Yes, for the most part I don't really worry about the "is a BPF LSM a
> LSM?" question, it's generally not important for most discussions.
> However, there is an issue unique to the BPF LSMs which I think is
> relevant here: there is no hook implementation code living under
> security/.  While I talked about a hook implementation being helpful
> to verify the hook prototype, it is also helpful in providing an
> in-tree example for other LSMs; unfortunately we don't get that same
> example value when the initial hook implementation is a BPF LSM.

I would argue that such a patch series must come together with a BPF
selftest which then i) contains an in-tree usage example, ii) adds BPF
CI test coverage. Shipping with a BPF selftest at least would be the
usual expectation.

Thanks,
Daniel
