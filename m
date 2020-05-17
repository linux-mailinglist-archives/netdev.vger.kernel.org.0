Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14E861D65E4
	for <lists+netdev@lfdr.de>; Sun, 17 May 2020 06:32:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726956AbgEQEcc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 May 2020 00:32:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726158AbgEQEcc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 May 2020 00:32:32 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39078C061A0C;
        Sat, 16 May 2020 21:32:32 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id u35so3051499pgk.6;
        Sat, 16 May 2020 21:32:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=HQHhVDubWhCu4+WobVqLFlUAQRD3gUWnmZ+RVTOl9+w=;
        b=byGDH694zauxl3F9SXY4S8/fFzjfOhzAd5i0owuTETElMpwvSBUb0fCp9P7ag5SwL+
         90/MpCCOvybhqI6zHPtwrNDyofVaxCcyGsLPcHcmV2gUC8omUp+N9SU22IO7KDPuGN72
         ltU+l1yRfuWk6mBDg7cF8rpKGAquDXb43hQ12aIoysLooZUybPvGAjJz1EdcfdWO8Uqz
         yA361/L/0ywI9+Nk6Nw5Ol/Qd/njNEviCZd9TAPKAtrIvU3taiJXXGJ2yDAi7Rayrt1e
         cj2ijBXOD2GaOSIie9BEsY5R3nEvSwGmoHEeZqmL48Sv12UxmHHjRX/s0yJGwX1aHs5w
         IUvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HQHhVDubWhCu4+WobVqLFlUAQRD3gUWnmZ+RVTOl9+w=;
        b=t3SU1Tl56V5xzY+4Gr/pVtOf4S+6Fh2Pm7Y0k+Hqd9Tz0t9Sg20RSUOvugokShtU1K
         H5qFgD/QGrYqF+LjIB/VYjKAXTdzkWuEK9j3WtgUzDBU0QfqoARPRePIslbbApecpqoc
         DzfBUHLRqJ7VbFaBYaK7vSxLfr3oD8j/+p+A4xBZ1PI3AqG+qod8Te0t9DAL/FjmGL8f
         jDTOvi+u0FtXLCDVQTw9EP5dEy/SHVWUBP9r+57szMXhEDEbL91rqN1p5X+GkB49O3mg
         9jUT0f7coccuHEyA/mGH0V+7psfLWCcfb5tRYSLHUwUCPPVaE5EV/SzcrnB9x5cssZUa
         DWsA==
X-Gm-Message-State: AOAM531rbPuA5P2p9/E6rQO1iVjhMfM9lQJ97y0ad1WuNvLEWaJjFCu3
        3ZCP5iFnvsiyDegkuoMvIpA=
X-Google-Smtp-Source: ABdhPJwLjSG7MJQLUnZPThrqs/Op/BWA5ROnyYH5Ipz35lufMVA/wMTHhtJacPbxUeUtpZVC6SsIyA==
X-Received: by 2002:a62:1b8f:: with SMTP id b137mr10822074pfb.119.1589689951555;
        Sat, 16 May 2020 21:32:31 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:280b])
        by smtp.gmail.com with ESMTPSA id j5sm5341392pfa.37.2020.05.16.21.32.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 May 2020 21:32:30 -0700 (PDT)
Date:   Sat, 16 May 2020 21:32:27 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>, ast@kernel.org,
        bpf@vger.kernel.org, netdev@vger.kernel.org, bjorn.topel@intel.com,
        magnus.karlsson@intel.com, lmb@cloudflare.com,
        john.fastabend@gmail.com
Subject: getting bpf_tail_call to work with bpf function calls. Was: [RFC
 PATCH bpf-next 0/1] bpf, x64: optimize JIT prologue/epilogue generation
Message-ID: <20200517043227.2gpq22ifoq37ogst@ast-mbp.dhcp.thefacebook.com>
References: <20200511143912.34086-1-maciej.fijalkowski@intel.com>
 <2e3c6be0-e482-d856-7cc1-b1d03a26428e@iogearbox.net>
 <20200512000153.hfdeh653v533qbe6@ast-mbp.dhcp.thefacebook.com>
 <20200513115855.GA3574@ranger.igk.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200513115855.GA3574@ranger.igk.intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 13, 2020 at 01:58:55PM +0200, Maciej Fijalkowski wrote:
> 
> So to me, if we would like to get rid of maxing out stack space, then we
> would have to do some dancing for preserving the tail call counter - keep
> it in some unused register? Or epilogue would pop it from stack to some
> register and target program's prologue would push it to stack from that
> register (I am making this up probably). And rbp/rsp would need to be
> created/destroyed during the program-to-program transition that happens
> via tailcall. That would mean also more instructions.

How about the following:
The prologue will look like:
nop5
xor eax,eax  // two new bytes if bpf_tail_call() is used in this function
push rbp
mov rbp, rsp
sub rsp, rounded_stack_depth
push rax // zero init tail_call counter
variable number of push rbx,r13,r14,r15

Then bpf_tail_call will pop variable number rbx,..
and final 'pop rax'
Then 'add rsp, size_of_current_stack_frame'
jmp to next function and skip over 'nop5; xor eax,eax; push rpb; mov rbp, rsp'

This way new function will set its own stack size and will init tail call
counter with whatever value the parent had.

If next function doesn't use bpf_tail_call it won't have 'xor eax,eax'.
Instead it would need to have 'nop2' in there.
That's the only downside I see.
Any other ideas?
