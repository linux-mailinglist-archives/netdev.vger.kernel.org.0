Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E637EA304E
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 08:58:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726716AbfH3G6k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 02:58:40 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:37637 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726005AbfH3G6j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 02:58:39 -0400
Received: by mail-pg1-f195.google.com with SMTP id d1so3052647pgp.4;
        Thu, 29 Aug 2019 23:58:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=9ktKnqeFqlycsKkhVinJovoy+hOX9LcZyegWFpj92Es=;
        b=cDtR7jIhLg9kD3FGmcEzHsMoZ+l0yXd9hOOEhBg8vBfbNfiRWj/Rd6Gmw1GB2793kg
         2MgjXFePqdhrxXEj3ZsbwpRGPZre+9TV98UgU6Njkqg/Igscw+QR1KsK8JK1NKBLhf57
         OJvP01L9q28T3OVTcVBz6wduRRFSK1ffeeEe+ACQX8bgcQ5pDgsVwA98viuAFfYVMdcL
         6zENwbbZWLl4TOQ9BJvFFUYsnL5n6yu8sCCdNZbupujEWHtur1JJrfB4/aaMndNB9769
         BDW0dJLn5RxpV3mzIAbmrBQuJ1CDBvGGZ03xI7wnLeuTLUkf1OPBngB4aotmQ5FFuMNV
         l5fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=9ktKnqeFqlycsKkhVinJovoy+hOX9LcZyegWFpj92Es=;
        b=pV6su2y5t8xlsCUqeYDLyoj2KvI1hPX+AAYgIbc1dEMcr7s8zg5may0hA/ZY+WeotZ
         q6iyp+l04/xOcbFkTUyZTAI1uGrlCQS5rVnXXQ2fKGuWhBUGvKKWQ3OzT3wEK6enf3Fo
         0MH5/sIy0ZHlvu/4e7dJSrjQn2MsC+J7JG6JYxaLkA3zMlE0yzkRko0XcffCTVrUmglJ
         0lFNzQcwRZ+lAFBOYvTQA6HGCABtUTFPuq8GEFCooWstIJTHG6LcZOIjBdb/H3P2PsYZ
         Hvko0TKsnWIBuxuPRTU4RtNUPQEE0Oi4hNGZ0PwnXH5+S774lhUVPWmku/pfHg9egAdI
         +HgA==
X-Gm-Message-State: APjAAAUuqIxFkA2hbo2DIkxN/9B7Qtj5lj11+XnFAiVN1xYmwCfczjkY
        J5qXf1ORTfd7PG2S1M4yydg=
X-Google-Smtp-Source: APXvYqwIU3miNi0JQwxIEeypPDwJFF+aiXOLsiw8GNrFRZDbc1Dszb8oDghU3kg1zu/r4e1M1vAGwA==
X-Received: by 2002:a17:90a:1a1a:: with SMTP id 26mr14243909pjk.118.1567148318926;
        Thu, 29 Aug 2019 23:58:38 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:180::5c37])
        by smtp.gmail.com with ESMTPSA id 24sm5343845pfo.3.2019.08.29.23.58.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Aug 2019 23:58:38 -0700 (PDT)
Date:   Thu, 29 Aug 2019 23:58:36 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Yonghong Song <yhs@fb.com>
Cc:     Brian Vazquez <brianvv@google.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 05/13] bpf: adding map batch processing support
Message-ID: <20190830065834.nppa6xxwdjenpey2@ast-mbp.dhcp.thefacebook.com>
References: <20190829064502.2750303-1-yhs@fb.com>
 <20190829064507.2750795-1-yhs@fb.com>
 <CAMzD94RuPs8_BHNRDjk6NDkyi=hJ+pCKeLb3ihACLYaOWz8sAA@mail.gmail.com>
 <2581bf69-2e35-fb10-7b84-3869286f6c85@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2581bf69-2e35-fb10-7b84-3869286f6c85@fb.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 30, 2019 at 06:39:48AM +0000, Yonghong Song wrote:
> > 
> > The problem happens when you are trying to do batch lookup on a
> > hashmap and when executing bpf_map_get_next_key(map, key, next_key)
> > the key is removed, then that call will return the first key and you'd
> > start iterating the map from the beginning again and retrieve
> > duplicate information.
> 
> Right. Maybe we can have another bpf_map_ops callback function
> like 'map_batch_get_next_key' which won't fall back to the
> first key if the 'key' is not available in the hash table?

The reason I picked this get_next_key behavior long ago
because I couldn't come up with a way to pick the next key consistently.
In the hash table the elements are not sorted.
If there are more than one element in the hash table bucket
they are added to the link list in sort-of random order.
If one out of N elems in the bucket are deleted which one should be
picked next?
select_bucket() picks the bucket.
if lookup_nulls_elem_raw() cannot find the element which one in
the link list is the "right one" to continue?
Iterating over hash table without duplicates when elements
are being added and removed in parallel is a hard problem to solve.
I think "best effort" is the right answer.
When users care about consistency they should use map-in-map.

