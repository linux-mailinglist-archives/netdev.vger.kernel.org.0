Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAA8A2FCF0A
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 12:21:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389210AbhATLRU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 06:17:20 -0500
Received: from mail.wangsu.com ([123.103.51.227]:43107 "EHLO wangsu.com"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388233AbhATKwU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Jan 2021 05:52:20 -0500
Received: from 137.localdomain (unknown [59.61.78.232])
        by app2 (Coremail) with SMTP id 4zNnewAHYIjSCghgSCoAAA--.122S2;
        Wed, 20 Jan 2021 18:49:55 +0800 (CST)
From:   Pengcheng Yang <yangpc@wangsu.com>
To:     ncardwell@google.com, ycheng@google.com
Cc:     netdev@vger.kernel.org, yangpc@wangsu.com
Subject: tcp: rearm RTO timer does not comply with RFC6298
Date:   Wed, 20 Jan 2021 18:49:54 +0800
Message-Id: <1611139794-11254-1-git-send-email-yangpc@wangsu.com>
X-Mailer: git-send-email 1.8.3.1
X-CM-TRANSID: 4zNnewAHYIjSCghgSCoAAA--.122S2
X-Coremail-Antispam: 1UD129KBjvdXoW7JryUuF47XF18tFyDAF1kXwb_yoWxArg_KF
        s29a18C39rua1Uta1ftw4fCw4aqrW7Gr45tr1kuFnxKFnrX3yrGa40gF4vk3Z7Ga4UXr9x
        Grs8GFyUG343tjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0rVWrJVCq3wA2ocxC64kI
        II0Yj41l84x0c7CEw4AK67xGY2AK021l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7
        xvwVC0I7IYx2IY6xkF7I0E14v26rxl6s0DM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84AC
        jcxK6I8E87Iv6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrV
        ACY4xI64kE6c02F40Ex7xfMcIj6x8ErcxFaVAv8VW8GwAv7VCY1x0262k0Y48FwI0_Jr0_
        Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2
        IErcIFxwCY02Avz4vE14v_Gw1l42xK82IYc2Ij64vIr41l42xK82IY6x8ErcxFaVAv8VW8
        GwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4
        vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IY
        x2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26c
        xKx2IYs7xG6Fyj6rWUJwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E
        14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x0JjxManUUUUU=
X-CM-SenderInfo: p1dqw1nf6zt0xjvxhudrp/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hi,

I have a doubt about tcp_rearm_rto().

Early TCP always rearm the RTO timer to NOW+RTO when it receives
an ACK that acknowledges new data.

Referring to RFC6298 SECTION 5.3: "When an ACK is received that
acknowledges new data, restart the retransmission timer so that
it will expire after RTO seconds (for the current value of RTO)."

After ER and TLP, we rearm the RTO timer to *tstamp_of_head+RTO*
when switching from ER/TLP/RACK to original RTO in tcp_rearm_rto(),
in this case the RTO timer is triggered earlier than described in 
RFC6298, otherwise the same.

Is this planned? Or can we always rearm the RTO timer to 
tstamp_of_head+RTO?

Thanks.

