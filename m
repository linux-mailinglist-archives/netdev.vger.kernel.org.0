Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8C4B1DD113
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 17:21:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729894AbgEUPVP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 11:21:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727898AbgEUPVP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 11:21:15 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CB9CC061A0F
        for <netdev@vger.kernel.org>; Thu, 21 May 2020 08:21:14 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id l1so5420644qvy.20
        for <netdev@vger.kernel.org>; Thu, 21 May 2020 08:21:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=9lkpAxU/Frlu8q2+TZv8WXsY+5fekFwCMxqOU2GbUws=;
        b=C459PlgMpa8qYr/Ahy0+Odf3EG4yZDSUOxlCSEUs+vVxwUqTKOmlVKvJpZ/abcX8fn
         7BtLnaWLCt0yWkz5ouOKN/pOmyT2AxSrampHkinUP48QYrjJT4PJ4QSaSuD3p0+yMASt
         eQKDY+G7Onm5nEfjgOj4YXTkrVikCzhyhE87IpPYsZo3K9DXDNu18MI1VSEAgBNJVowx
         ZRzjq1oAVSVpo/2S/65Sy0/bdqNPRlD5YXdYouIcqJtB7BeqZp6h6JXToBjAH3Oy951D
         mSwSHZMLXUTArnfK0RGWZRNCAwNW6o2zePN8a0nyL9gGEfRxr5xuoLgiJuiX2RK4YGQm
         m9UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=9lkpAxU/Frlu8q2+TZv8WXsY+5fekFwCMxqOU2GbUws=;
        b=BBm+1S9avL3aucAJY+F49Ew+0sGMHnFJy11QYT1VrNkt2r15LbISfAvfNKEw2ha3OJ
         RzjEmYHdm6qaKIjr1SMA4qOAom0pB3xS7CgNyIfupAuY8J/02UW1njHPfkDqzzjQpjqj
         FNIvtha8TYnkoNOZkpLM5DjnFAIlFr+X2sVWI5oQBNRJmSRL3zRfsglW22cPgMp+Z/Di
         tIwStMb6jIZ+/LZGeMx45QTBKw7QvtNyCApRWpGwlM7bH2kerYyBa/q4g/KAnFzJTEBD
         J82gJ/9SWWe0Dz5MP2zbf7x4kN/vTCEs3csyV+hXNTRJ2tjKHJzGtmyYOs7I3vZiwIUk
         svvQ==
X-Gm-Message-State: AOAM530hKtsRT5O92Q0lIC1hi5Zba/jmsFbQh7oYeQp+lFdydp8GUxId
        K9j0dHzsM9XFk0Mi5zqDXMpU8+4=
X-Google-Smtp-Source: ABdhPJwEeEqc2SIIxOIk9bV5/VcJvZjsEaWLrXJuywDArF1hfveBKPIGJL/MpTKGOkINxIeFM/xgsEY=
X-Received: by 2002:a0c:906e:: with SMTP id o101mr10478572qvo.180.1590074473192;
 Thu, 21 May 2020 08:21:13 -0700 (PDT)
Date:   Thu, 21 May 2020 08:21:11 -0700
In-Reply-To: <20200521083435.560256-1-jakub@cloudflare.com>
Message-Id: <20200521152111.GB49942@google.com>
Mime-Version: 1.0
References: <20200521083435.560256-1-jakub@cloudflare.com>
Subject: Re: [PATCH bpf v2] flow_dissector: Drop BPF flow dissector prog ref
 on netns cleanup
From:   sdf@google.com
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        kernel-team@cloudflare.com,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/21, Jakub Sitnicki wrote:
> When attaching a flow dissector program to a network namespace with
> bpf(BPF_PROG_ATTACH, ...) we grab a reference to bpf_prog.

> If netns gets destroyed while a flow dissector is still attached, and  
> there
> are no other references to the prog, we leak the reference and the program
> remains loaded.

> Leak can be reproduced by running flow dissector tests from selftests/bpf:

>    # bpftool prog list
>    # ./test_flow_dissector.sh
>    ...
>    selftests: test_flow_dissector [PASS]
>    # bpftool prog list
>    4: flow_dissector  name _dissect  tag e314084d332a5338  gpl
>            loaded_at 2020-05-20T18:50:53+0200  uid 0
>            xlated 552B  jited 355B  memlock 4096B  map_ids 3,4
>            btf_id 4
>    #

> Fix it by detaching the flow dissector program when netns is going away.

> Fixes: d58e468b1112 ("flow_dissector: implements flow dissector BPF hook")
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
Reviewed-by: Stanislav Fomichev <sdf@google.com>

Thank you!
