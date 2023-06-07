Return-Path: <netdev+bounces-9040-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EEBF0726B3F
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 22:24:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B49D92813CA
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 20:24:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 157633AE4C;
	Wed,  7 Jun 2023 20:24:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B24183AE48
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 20:24:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B9EDC4339B;
	Wed,  7 Jun 2023 20:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686169447;
	bh=YgtKo1CwCzUIG1yu6hI+fXt3Ni+CnNL+GRS6e4XMsNw=;
	h=From:To:Cc:Subject:Date:From;
	b=oyMdb4RYaZUeAHhAWnMaTLG8hcgJNFoEZFfgu8hTSU7zRrKOo/VvcnqxZzrwn2mEK
	 r8BswRBGMfZ+ULLQlFZuMRGWVXX7KyVSS62Op+0BadKjl/mEjIRHNlftSYs96RoenW
	 NXyusTxDLS9Dh9uf5SnwK5ifoWrVM0pmw8fRFiT2/oYEqn1LhRXauH1kx+L5RD2jun
	 ht6+qhBf0CKomjHlybGBBHXYiquy8YTYCLrkbhe+vgrnhAgG7XFRAUXUrIRza+xZ70
	 AMNsfVEZHhx1KmGerePPnCxkKoN3vYpB1/4yHVjrKrrymdWlH9Umm/+uOi6181MlIe
	 pt9CWgi0xo+Kw==
From: Jakub Kicinski <kuba@kernel.org>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org,
	edumazet@google.com,
	pabeni@redhat.com,
	jiri@resnulli.us,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 00/11] tools: ynl: generate code for the devlink family
Date: Wed,  7 Jun 2023 13:23:52 -0700
Message-Id: <20230607202403.1089925-1-kuba@kernel.org>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Another chunk of changes to support more capabilities in the YNL
code gen. Devlink brings in deep nesting and directional messages
(requests and responses have different IDs). We need a healthy
dose of codegen changes to support those (I wasn't planning to
support code gen for "directional" families initially, but
the importance of devlink and ethtool is undeniable).

I have 1 more series like this (ethtool support).

Jakub Kicinski (11):
  netlink: specs: devlink: fill in some details important for C
  tools: ynl-gen: use enum names in op strmap more carefully
  tools: ynl-gen: refactor strmap helper generation
  tools: ynl-gen: enable code gen for directional specs
  tools: ynl-gen: try to sort the types more intelligently
  tools: ynl-gen: inherit struct use info
  tools: ynl-gen: walk nested types in depth
  tools: ynl-gen: don't generate forward declarations for policies
  tools: ynl-gen: don't generate forward declarations for policies -
    regen
  tools: ynl: generate code for the devlink family
  tools: ynl: add sample for devlink

 Documentation/netlink/specs/devlink.yaml |   8 +
 tools/net/ynl/generated/Makefile         |   2 +-
 tools/net/ynl/generated/devlink-user.c   | 721 +++++++++++++++++++++++
 tools/net/ynl/generated/devlink-user.h   | 210 +++++++
 tools/net/ynl/generated/fou-user.c       |   3 -
 tools/net/ynl/generated/handshake-user.c |   4 -
 tools/net/ynl/generated/netdev-user.c    |   2 -
 tools/net/ynl/lib/nlspec.py              |  11 +-
 tools/net/ynl/samples/.gitignore         |   1 +
 tools/net/ynl/samples/devlink.c          |  60 ++
 tools/net/ynl/ynl-gen-c.py               | 137 +++--
 11 files changed, 1101 insertions(+), 58 deletions(-)
 create mode 100644 tools/net/ynl/generated/devlink-user.c
 create mode 100644 tools/net/ynl/generated/devlink-user.h
 create mode 100644 tools/net/ynl/samples/devlink.c

-- 
2.40.1


