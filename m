Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 695E96BC815
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 09:02:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230321AbjCPICO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 04:02:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230322AbjCPICJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 04:02:09 -0400
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6E1354C8F;
        Thu, 16 Mar 2023 01:02:00 -0700 (PDT)
Received: from maxwell.fritz.box ([109.42.114.157]) by
 mrelayeu.kundenserver.de (mreue011 [213.165.67.97]) with ESMTPSA (Nemesis) id
 1N5VXu-1qZOzS1ix8-016vCE; Thu, 16 Mar 2023 09:00:48 +0100
From:   Jochen Henneberg <jh@henneberg-systemdesign.com>
To:     netdev@vger.kernel.org
Cc:     Jochen Henneberg <jh@henneberg-systemdesign.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net V2 0/2] net: stmmac: Premature loop termination check was ignored
Date:   Thu, 16 Mar 2023 08:59:38 +0100
Message-Id: <20230316075940.695583-1-jh@henneberg-systemdesign.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230314123759.132521-1-jh@henneberg-systemdesign.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:MF+CTOsuaUq00JRKYZHVnsChLb87wgi4uQ1NbzyyNpJIXRd8oR5
 W4ykBIg0Us5rgmf3C88AvJGFzY9e+D57+Muxbny4/4lOA9pbdfO5pBjBUS0iZsgTHfr1xxa
 vmPbcloq4rtlnFdDspnr2Fi4ReAvnQz+VoN8wpBVhmTesVvd8xPjyBga/xKDXzGiYtxymLg
 Hz52hJjfworWMxsM6lXCg==
UI-OutboundReport: notjunk:1;M01:P0:LIoPf2/TAMs=;QhWFGVa7tyxykKcxVcjlZU+BKF5
 vMT3NkA0jzP5P3RSpMMkPS8EMvKA6XdEyS7Tkktzuy7QZKP4p1vMYCgSgI0w9wVrCF0UonIoh
 5NY+ssi7US/JeldnU15MfQxTsqeZ9daTF3qpmCiCNoKeogTlupK0lFuXzPaCTQ/9EH8CrpGlf
 bXb+oyzUSUHtN6HKn+jaq6857IalkzXBLl5izpyxCYP6YBtR9KQDfpfkZzKp26pPaBFv6PAfj
 8ho4vqYOIyQsL7+5uskISN5ASCrHm0mCGsFT2uw/FwEPzfx/djOupNC7+c1I9BcL21KBkk3g3
 fQZBFKHnfp36vCPUrV9voYEDFcRgOcWyZi72szFR8n+gF5ejb22z60w+n0k7RSLjv3FicU7Ah
 V5nXW9OK51OW8p60ODhXkTQkZgqQxWKoyG8Hxf9z4402qEL13QROPZQzUtUrNe134Hepggwad
 B7izy25PSjIBDhp9iCaBTokYuHwLKPimF2x9nmWwXJB3RvHnV+TQtcQDtf3rPJiu1TluSIHvG
 DoY2WREu2848EqBILmSIbKoIapyfnchC8okgVLSO6UDi2e7H4WV97M8cXBYBl9USVw9VV5ZJe
 5dudodI/nlN87VoLwou1SVpypHp5Me+HTcd94RFufT2RgodBFNRqgHTTmp6MMaInGfYwK9w9O
 fxDQe4JTllrua943bYeBHl+r4l0ZSJTSvF4bBPqc4g==
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As proposed in [1] here is are the fixes as a patch series that do the
premature end-of-loop check within the goto loop.

The commit messages now tell us which rx path has been fixed.

Jochen Henneberg (2):
  net: stmmac: Premature loop termination check was ignored on rx
  net: stmmac: Premature loop termination check was ignored on ZC rx

 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

[1] https://lore.kernel.org/all/Y%2FdiTAg2iUopr%2FOy@corigine.com
-- 
2.39.2

