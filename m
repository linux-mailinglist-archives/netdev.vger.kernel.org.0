Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A725617EE47
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 02:58:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726510AbgCJB6a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 21:58:30 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:39305 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726156AbgCJB63 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 21:58:29 -0400
Received: by mail-pl1-f193.google.com with SMTP id j20so4770776pll.6
        for <netdev@vger.kernel.org>; Mon, 09 Mar 2020 18:58:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fWnA8T5CP/DhcV7JPGIDFroDx0hTfxlqHKDx/iWDFN4=;
        b=pMNy9MnFkkRWw9CPyFfnt7H0Wfk5yp8nksuXhzRrJBXCLI9uH3KXK298DFCkiW5QLk
         j1GoNDzsx0wBUNuz8wSsC2OaMfAnZNpj2osX778ZBVElpw7lmv7RDg8S+lO4JGmAuV9r
         HPDD1Aw7KQipyOYeT/sMy3jpX5BqapzEc007V92QPq5Z3jrBtSst/90/10AD9Nd0LeI6
         9sXF4OP9L+ibEKbFu2dJlHHbEZbLeZoSVKF+ACcFCToxvV6qKCFbCA7KI4Iw7ZBwlivR
         VlVnJmlmtvhiWqL8YZrnWFRwDImr9+s9spD31JPYjERg67M7S6CKgXqVchQ+5fttaQ2p
         UNlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fWnA8T5CP/DhcV7JPGIDFroDx0hTfxlqHKDx/iWDFN4=;
        b=bOqbxYjJE99PFvnzhMBM6f8J/ZQVcjaBuShI2AOxEYZ8TMOI9Mf00J2qPC4Zvp7mo6
         st61Ex8udb3v/SvPLiky7SeYvU+i/Bk3o+L8g8N4RjdxFadGl4/bqi5aiHetxtUAC+Pg
         xC3To0T/bITmDxZxHgXEy/AIk2WBiJ46UUJKXuLvbI9boedtNRRtmYVG+36bxZFVwWuh
         XmMMiNGmwo4m2H6ORYHvWXZobjQywjZ1yIHnJgeXWxAMPRvGwHyXL0XFPapSvR4h6GxG
         3HdCPTspg2jG8A9I/h7bTrZXCJl5bCHg+C48zP6Jv8GmLtjY9+3DLSn4jAlb7+e6oCca
         zG6A==
X-Gm-Message-State: ANhLgQ2pwwtzRNQkmIEk73/UTrCM1PIfAwaUo6BgYCvBs6K/NairQjEe
        Zgk5Vxn9E3c33oGAO8O/yGY=
X-Google-Smtp-Source: ADFU+vvBtMGpbBPryBCTe8rWq2HdaU+9IAcZMDT9kUfKZayNYuY3d8PWIaMTP4np8cAv/aRRZfxFkQ==
X-Received: by 2002:a17:90a:fa0f:: with SMTP id cm15mr2282808pjb.110.1583805507227;
        Mon, 09 Mar 2020 18:58:27 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id y7sm5715110pfq.159.2020.03.09.18.58.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Mar 2020 18:58:26 -0700 (PDT)
Subject: Re: [PATCH net] ipvlan: do not use cond_resched_rcu() in
 ipvlan_process_multicast()
To:     David Miller <davem@davemloft.net>, edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com, maheshb@google.com
References: <20200310012258.196797-1-edumazet@google.com>
 <20200309.183310.64095245470909485.davem@davemloft.net>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <82512911-5e8f-f60f-971c-9c1b4249dadd@gmail.com>
Date:   Mon, 9 Mar 2020 18:58:25 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200309.183310.64095245470909485.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/9/20 6:33 PM, David Miller wrote:
> From: Eric Dumazet <edumazet@google.com>
> Date: Mon,  9 Mar 2020 18:22:58 -0700
> 
>> Commit e18b353f102e ("ipvlan: add cond_resched_rcu() while
>> processing muticast backlog") added a cond_resched_rcu() in a loop
>> using rcu protection to iterate over slaves.
>>
>> This is breaking rcu rules, so lets instead use cond_resched()
>> at a point we can reschedule
>>
>> Fixes: e18b353f102e ("ipvlan: add cond_resched_rcu() while processing muticast backlog")
>> Signed-off-by: Eric Dumazet <edumazet@google.com>
>> Cc: Mahesh Bandewar <maheshb@google.com>
> 
> Applied, thanks for the quick fix Eric.
> 

Sure thing ;)
