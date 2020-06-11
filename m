Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48C6E1F6DA2
	for <lists+netdev@lfdr.de>; Thu, 11 Jun 2020 20:51:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727787AbgFKSvU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jun 2020 14:51:20 -0400
Received: from mout.web.de ([212.227.17.12]:38831 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726159AbgFKSvT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Jun 2020 14:51:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1591901459;
        bh=K4VnlmIMmt2H+6LejIAOIjQN8Plwr3oGRWVaDnWDKAM=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=m92ByOje1cHc9qapcg0++LG3An4fKXMNVx8CoAH9xjfSl8wZ8hQJqIOKZe3yf8Uu4
         6Cb63p67AuMyax3rkfx0Oi1WDPbEw4auygZRivxKivMgGiqjxjFIMYWkCznI6g8gjj
         iSFZ+MI8mesozVI+dPXTp4kEX+Jb5Efb9Ke1XStU=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([78.49.66.14]) by smtp.web.de (mrweb101
 [213.165.67.124]) with ESMTPSA (Nemesis) id 0M89mf-1ixNuE24Jt-00vhhq; Thu, 11
 Jun 2020 20:50:59 +0200
Subject: Re: [PATCH v2 1/2] perf tools: Fix potential memory leaks in perf
 events parser
To:     Cheng Jian <cj.chengjian@huawei.com>,
        Chen Wandun <chenwandun@huawei.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
References: <20200611145605.21427-1-chenwandun@huawei.com>
 <20200611145605.21427-2-chenwandun@huawei.com>
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <51efcf82-4c0c-70d3-9700-6969e6decde1@web.de>
Date:   Thu, 11 Jun 2020 20:50:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200611145605.21427-2-chenwandun@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
X-Provags-ID: V03:K1:yiAsCXN0qgyKzCW+7aPj8Lu1FS3gP8ymz/mkcVrw+bUNUgazHlq
 GV9blg4tWMUSMSdHdM0IX+JluRKM1plEOr3PP4vTjBxYrvR6TrsH5A0n1RLuxkEuXRZAgoi
 8BtNX+CTFSlUikBv282DmiWrNmv9xaXjs84NW6Wchd4ADZYBraU3TWXdjJv42m6ZY9r0ee1
 LMkB5UXvPy+2jtg/eYdOg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:a7BhrGoOUK0=:Kd9+CKPF/5kFIN06UtRHRq
 4n5hYPUu92AVG5QnpHxAjObrcBXWye4n++RZdCCa78lE7m5QV+PqamSOEtq9MoBv12W0J/3YA
 jA11z6BqnKy/LqijZqNn6v9wxM12h5vjb27rO6xHfpbyGupRouyhuQTBaEz5BOC4j8fTs0l9F
 lxzIaOjuN//b+VVEidx+TkfxNgfke2/dtMck77Hed2NxYZl5BXeu4khsIOjQ4XZM1766xYcp0
 GPw5qpSMC/gEnm+MtM719RMxQAwsPM88tXjgpwpol/5EEjuwfblvi/fZmiXrOIfi4E77WES2Y
 Jq90DLnG/GuXUEYCyrSxuGnqxSOnj8KABK//G7hZeEBYq7D+uDZuP5WJZ/SYRV3GmscMNJWpt
 0iz/6w05HpxOlX8kxvP+ZDTyD3pFYHVelJVFL7Wm2kKhPnzykg+AB5Ir/bHexgbG3zFG+mS92
 mptKhvKKIw4TwaMXInZ2B4S/TRRTQ50bTwn4cssivU/t6jjt0qODT+BAmLAz51tczMe2zRDYB
 4YcCT7HOoyRhdtTksg5saJz5Dcz1S2RWvhbIXanTO+BgCXsCxOmeSs6Qvu0mC5KfvGwO9Q7bW
 c69iVCtlMNSTRARlAo9dkE1V1x132oCiMsaneCrs7Svb4IWZgo8B0LYshABxfnb1s9roxH+vG
 rlP/gU4f0k0RkOX8iOkHbK0KdhYqNpPn6CCYd6NTrOoBQA+qkA0cm72wEcU5BTpIKqLCIr0dy
 DkPWclCCFznDzPKGTLdUZcBp771lggKhc4XY9k4Wg16W9tQF+s6ZsVWIASKfg8ALTg+eAJmZ0
 qkrwwUubALodWBdvUsiAuvbsO3SKxjUi28n/kQVHb1ocKaYR8ZoRzGGU/uf9EHyHPCka8nVEP
 cfnHXJIB1zT+Y650/wFb2R2r1nDPKqJnl3SRqzcH84K6rge2OadhZyYOfjhTFnvV87RfhaU2z
 2mJnc/XmTSGWzM7/yn/YTvCPO3QFieed+3EP+vgIYnvsvowrwHWG7OjHrT1MaHFttT6eoblNB
 Y8X2gJxbLilWPQ6A0ghsaQYsbyWHvvT2Gros3LH82Ikr7XnKw5lkhsPa0XyT7kZKkaBQY5hD6
 Y06YHqUnRYfY10WJQ0DXPezqLy8VVs51pso73eDy3/R2t+tEkzzWHh1jQCuluuvaR/PNv/AcI
 AxyC0cKhQbTPRGq++xIMagbFykjkvnppaUJ8x+ZqMcfGrkY8Ts8fZrAxJAStmZxZysZomc+YD
 2JkRh0Yn4WrIyJReP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Fix memory leak of in function parse_events_term__sym_hw()
> and parse_events_term__clone() when error occur.

How do you think about a wording variant like the following?

   Release a configuration object after a string duplication failed.

Regards,
Markus
