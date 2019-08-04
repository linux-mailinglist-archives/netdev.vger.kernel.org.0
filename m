Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1C8A80A17
	for <lists+netdev@lfdr.de>; Sun,  4 Aug 2019 11:39:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726030AbfHDJjR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Aug 2019 05:39:17 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:33704 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725941AbfHDJjR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Aug 2019 05:39:17 -0400
Received: by mail-ot1-f66.google.com with SMTP id q20so82363512otl.0
        for <netdev@vger.kernel.org>; Sun, 04 Aug 2019 02:39:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=neemtree-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=LIYWSVNBGpLw86fEBNo+fD1NzgAc4PcVm8JgJoAGe/0=;
        b=Q1i39rgExab+Q7htBRSe2vbbulu/zztKloRMgygIJO9JAKWMYzne6msPHGbfCVhj+P
         RnwlzMbtYuhBc36j2l7A3+W/Pi/lBQ6cfqE3RzLL/lTKJG9cfuKLNW9v+5MQeL5T1qD0
         OYRQNsoH0GQKqO4ZsbLluJZE9SI/ycy1xs4Hsyp8e3zZc7K7qVn8hnWTVUDaGZpjKRGL
         ZCQ47KASqDI5NJjxhAjPNYAt9OJQ48QvMkaLlQ1LtxBi76aL1D/vf85sGilIsJIsEN0d
         7T32bGADD93MuGwij/Ti32DzT+om6BkyzVG/igbEx6uV5OKUFCjtKwSxSmrG5DJOTJ4Y
         UIYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=LIYWSVNBGpLw86fEBNo+fD1NzgAc4PcVm8JgJoAGe/0=;
        b=HCiXfG5XRBczOtbNjpgweVS/BsF0W86agKq0lDTRrYzfXED5U8QleFCcZLqZAU+agZ
         Qax/VonRcgDleirAKLp+toWhimxdw8OyfiithCKKSampgHhkcjN9nJrJCeK0vs/maPRe
         9VEXnFgdWExaO8y9cfd2l9P49LZlAPW0CyYpgkJ+21/j917/WosWoAe0srxpUulbU/C8
         8OBeCpuAFyCRbeN/Q3fc6p8ug8BOptIXuCUJMYh7CZdknyQkFbkQ8BUHU4x/Vz/uFn7L
         TrRiWeXFGgaF7ukWMOz5TkMLUkueg03LFdnjsE7p/4eqpjxNZlulKQEHVEeuP1I6PFB6
         nU3Q==
X-Gm-Message-State: APjAAAWmeerdFwqyzQ0LhBeIAM9WFvbILxO15Pg7AMsnAy7KSpt+FreT
        sEzAfA8g7PqddtWUYtiRyV3zW+euBwMlwyJndeZs8IZE
X-Google-Smtp-Source: APXvYqx3+fpefwLD2MZOI/HGgJPv+YddJM61I3FGpFPiua0Cfg4TbR7oNKDocNhaJJdWDYCPl9fEY4hEUpSvNORS1RQ=
X-Received: by 2002:a9d:61c7:: with SMTP id h7mr35895350otk.357.1564911555804;
 Sun, 04 Aug 2019 02:39:15 -0700 (PDT)
MIME-Version: 1.0
References: <CADJe1ZsN8+1brBNdN2VNMp4PRdeYjCC=qaMZALQxOTvPmgJQhA@mail.gmail.com>
In-Reply-To: <CADJe1ZsN8+1brBNdN2VNMp4PRdeYjCC=qaMZALQxOTvPmgJQhA@mail.gmail.com>
From:   Shridhar Venkatraman <shridhar@neemtree.com>
Date:   Sun, 4 Aug 2019 15:09:02 +0530
Message-ID: <CADJe1ZsZcWrtdJGgXeoEnG4FFUGxT-BmJvJW2xwDUF+uCUp-kA@mail.gmail.com>
Subject: Re: BPF: ETLS: RECV FLOW
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The eTLS work has BPF integration which is great.
However there is one spot where access to the clear text is not available.

From kernel 4.20 - receiver BPF support added for KTLS.

a. receiver BPF is applied on encrypted message
b. after applying BPF, message is decrypted
c. BPF run logic on the decrypted plain message   - can we add this support ?
d. then copy the decrypted message back to userspace.

code flow reference: tls receive message call flow:
--------------------------------------------------------------

tls_sw_recvmsg
  __tcp_bpf_recvmsg [ bpf exec function called on encrypted message ]
  decrypt_skb_update
  decrypt_internal
  BPF_PROG_RUN on decrypted plain message - can we add this support ?
  skb_copy_datagram_msg [ decrypted message copied back to userspace ]

Thanks
ps: I sent this to the bpf list as I don't know which one it should go to
