Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B05556C02
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 16:31:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728155AbfFZObr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 10:31:47 -0400
Received: from www62.your-server.de ([213.133.104.62]:44494 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725958AbfFZObq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 10:31:46 -0400
Received: from [78.46.172.2] (helo=sslproxy05.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hg8xc-0000Wx-A4; Wed, 26 Jun 2019 16:31:44 +0200
Received: from [2a02:1205:5054:6d70:b45c:ec96:516a:e956] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hg8xc-0004jT-47; Wed, 26 Jun 2019 16:31:44 +0200
Subject: Re: [PATCH bpf] bpf: fix BPF_ALU32 | BPF_ARSH on BE arches
To:     Jiong Wang <jiong.wang@netronome.com>, alexei.starovoitov@gmail.com
Cc:     yauheni.kaliuta@redhat.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org, oss-drivers@netronome.com
References: <1561480910-23543-1-git-send-email-jiong.wang@netronome.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <ff240422-35b8-8001-819b-e819364c0dcf@iogearbox.net>
Date:   Wed, 26 Jun 2019 16:31:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <1561480910-23543-1-git-send-email-jiong.wang@netronome.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25492/Wed Jun 26 10:00:16 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/25/2019 06:41 PM, Jiong Wang wrote:
> Yauheni reported the following code do not work correctly on BE arches:
> 
>        ALU_ARSH_X:
>                DST = (u64) (u32) ((*(s32 *) &DST) >> SRC);
>                CONT;
>        ALU_ARSH_K:
>                DST = (u64) (u32) ((*(s32 *) &DST) >> IMM);
>                CONT;
> 
> and are causing failure of test_verifier test 'arsh32 on imm 2' on BE
> arches.
> 
> The code is taking address and interpreting memory directly, so is not
> endianness neutral. We should instead perform standard C type casting on
> the variable. A u64 to s32 conversion will drop the high 32-bit and reserve
> the low 32-bit as signed integer, this is all we want.
> 
> Fixes: 2dc6b100f928 ("bpf: interpreter support BPF_ALU | BPF_ARSH")
> Reported-by: Yauheni Kaliuta <yauheni.kaliuta@redhat.com>
> Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> Reviewed-by: Quentin Monnet <quentin.monnet@netronome.com>
> Signed-off-by: Jiong Wang <jiong.wang@netronome.com>

Applied, thanks!
